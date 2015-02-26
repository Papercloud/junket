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
  belongs_to :sequence_template

  validates_presence_of :send_at, :action_template, :sequence_template, :object

  has_one :sequence_template, through: :action_template

  # State machine to manage waiting/scheduled/sent state.
  include AASM
  aasm column: :state do
    state :waiting, initial: true
    state :scheduled, before_enter: :schedule_delivery
    state :sent, before_enter: :send_everything

    event :deliver do
      transitions from: :scheduled, to: :sent
    end

    event :schedule do
      transitions from: :waiting, to: :scheduled
    end
  end

  ## Targeting

  # Number of targets meeting this campaign's FilterConditions at this point in time.
  def targets_count
    @targets_count ||= targets.count
  end

  # Apply filters to decide the recipients
  def finalize_recipients
    targets.each do |target|
      # TODO: Put each recipient on another job to keep per-job execution time low?
      recipient = Junket::Recipient.new(target: target, campaign: self)
      recipient.save!
    end
  end

  private

  # Schedule a Sidekiq job to deliver in the future, at 'send_at'
  def schedule_delivery
    # Schedule to send in the future
    self.class.delay.finalize_and_deliver(id, send_at)
  end

  # Do the work of sending out a campaign.
  # Don't call this directly, use the 'send' state machine event instead.
  def send_everything
    recipients.each do |recipient|
      send_sms_to(recipient) if self.send_sms?
      send_email_to(recipient) if self.send_email?
    end
  end

  # Sends the campaign's SMS body to a recipient.
  def send_sms_to(recipient)
    if Junket.sms_adapter && Junket.sms_from_name
      # TODO: DSL for declaring on a target class which property to use for its mobile number.
      # TODO: DSL for declaring which of the owner's properties becomes the 'sms_from_name': it shouldn't be defined globally.

      body_template = Liquid::Template.parse(sms_body)
      body = body_template.render(recipient.target.class.name.underscore => recipient.target)
      Junket.sms_adapter.constantize.send_sms(recipient.target.mobile, body, Junket.sms_from_name)
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
      owner.name,
      owner.email)

    # Save the email's unique identifier, so we can receive a webhook to tell when it has been opened or clicked.
    recipient.email_third_party_id = email_id
    recipient.save!
  end

  # Finalize recipients, and send or schedule when done.
  def self.finalize_and_deliver(id, send_at)
    campaign = find_by_id(id)
    return unless campaign

    puts "Finalizing Campaign #{id}"

    campaign.finalize_recipients

    puts "Targeted #{campaign.recipients.count} Recipients for Campaign #{id}"

    if send_at
      puts "Delivery of Campaign #{id} scheduled for #{send_at}"
      self.class.delay_until(send_at).deliver_instance(id)
    else
      puts "Delivering Campaign #{id} now"
      self.class.deliver_instance(id)
    end
  end

  # Class method used as a Sidekiq worker
  def self.deliver_instance(id)
    campaign = find_by_id(id)
    campaign.deliver!
  end
end
