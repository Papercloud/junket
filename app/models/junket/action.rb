# == Schema Information
#
# Table name: junket_actions
#
#  id                 :integer          not null, primary key
#  action_template_id :integer          not null
#  object_id          :integer          not null
#  object_type        :string(255)      not null
#  state              :string(255)      not null
#  run_datetime       :datetime         not null
#  created_at         :datetime
#  updated_at         :datetime
#

# Each event in a sequence, this has details of low level events such as an sms being sent and when.
class Junket::Action < ActiveRecord::Base
  # attr_accessible :state
  belongs_to :object, polymorphic: true
  belongs_to :action_template

  validates_presence_of :run_datetime, :action_template, :sequence_template, :object_id, :object_type # allow objects that dont exist to not invalidate the action

  has_one :sequence_template, through: :action_template
  has_many :recipients

  # State machine to manage waiting/scheduled/sent state.
  include AASM
  aasm column: :state do
    state :waiting, initial: true
    state :scheduled # , before_enter: :schedule_delivery, #KG, had to just rely on the deliver event calling this instead.
    state :sent, before_enter: :send_everything

    event :deliver do
      transitions from: :scheduled, to: :sent
      after do
        action_template.create_next_action(self)
      end
    end

    event :schedule do
      transitions from: :waiting, to: :scheduled
      after do
        send(:schedule_delivery)
      end
    end
  end

  # def destroy
  # destroy the old sidekiq job.
  # end

  ## Targeting

  def targets
    base_targets = Junket.targets.call(self)

    # Build Ransack query with all filter conditions
    query = action_template.filter_conditions.each_with_object({}) do |condition, q|
      q[condition.filter.term] = condition.value
    end

    base_targets.search(query).result(distinct: true)
  end

  # Number of targets meeting this campaign's FilterConditions at this point in time.
  def targets_count
    @targets_count ||= targets.count
  end

  # Apply filters to decide the recipients
  def finalize_recipients
    targets.each do |target|
      # TODO: Put each recipient on another job to keep per-job execution time low?
      recipient = Junket::Recipient.new(target: target, action: self)
      recipient.save!
    end
  end

  private

  # Schedule a Sidekiq job to deliver in the future, at 'run_datetime'
  def schedule_delivery
    # Schedule to send in the future
    self.class.delay.finalize_and_deliver(id, run_datetime)
  end

  # Do the work of sending out a campaign.
  # Don't call this directly, use the 'send' state machine event instead.
  def send_everything
    recipients.each do |recipient|
      send_sms_to(recipient) if action_template.send_sms?
      send_email_to(recipient) if action_template.send_email?
    end
  end

  # Sends the campaign's SMS body to a recipient.
  def send_sms_to(recipient)
    if Junket.sms_adapter && Junket.sms_from_name
      # TODO: DSL for declaring on a target class which property to use for its mobile number.
      # TODO: DSL for declaring which of the owner's properties becomes the 'sms_from_name': it shouldn't be defined globally.

      body_template = Liquid::Template.parse(action_template.resolve_sms_body(self))
      body = body_template.render(recipient.target.class.name.underscore => recipient.target)

      if action_template.should_send_sms?(self)
        Junket.sms_adapter.constantize.send_sms(recipient.target.mobile, body, Junket.sms_from_name)
      end

    else
      fail 'Please set config.sms_adapter and config.sms_from_name in your Junket initialiser'
    end
  end

  # Sends the campaigns email to a recipient.
  def send_email_to(recipient)
    subject_template = Liquid::Template.parse(email_subject)
    body_template = Liquid::Template.parse(email_body)

    email_id = Junket.email_adapter.constantize.send_email(
      # TODO: Need to define this interface, or have a DSL to declare it.
      recipient.target.email,
      recipient.target.full_name,
      # TODO: Need to define campaign owner interface for sender name and email.
      subject_template.render(recipient.target.class.name.underscore => recipient.target),
      body_template.render(recipient.target.class.name.underscore => recipient.target),
      owner.try(:name),
      owner.try(:email))

    # Save the email's unique identifier, so we can receive a webhook to tell when it has been opened or clicked.
    recipient.email_third_party_id = email_id
    recipient.save!
  end

  # Finalize recipients, and send or schedule when done.
  def self.finalize_and_deliver(id, run_datetime)
    action = find_by_id(id)
    return unless action

    puts "Finalizing Action #{id}"

    action.finalize_recipients
    # I just have to save here
    action.save!

    puts "Targeted #{action.recipients.count} Recipients for Action #{id}"

    if run_datetime
      puts "Delivery of Action #{id} scheduled for #{run_datetime}"
      if action_template.should_queue?
        delay_until(run_datetime).deliver_instance(id)
      end
    else
      puts "Delivering Action #{id} now"
      deliver_instance(id)
    end
  end

  # Class method used as a Sidekiq worker
  def self.deliver_instance(id)
    action = find_by_id(id)
    action.deliver! if action
  end
end
