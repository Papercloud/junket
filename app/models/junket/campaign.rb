# == Schema Information
#
# Table name: junket_campaign_templates
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  campaign_name :string(255)
#  email_subject :string(255)
#  email_body    :text
#  sms_body      :text
#  send_email    :boolean          default(TRUE), not null
#  send_sms      :boolean          default(TRUE), not null
#  created_at    :datetime
#  updated_at    :datetime
#  type          :string(255)
#  state         :string(255)
#  send_at       :datetime
#

# Represents a single send-out of emails and SMSs to many users.
class Junket::Campaign < Junket::CampaignTemplate
  has_many :recipients, dependent: :delete_all

  # State machine to manage draft/scheduled/sent state.
  include AASM
  aasm column: :state do
    state :draft, initial: true
    state :scheduled, before_enter: :schedule_delivery
    state :sent, before_enter: :send_everything

    event :deliver do
      transitions from: :scheduled, to: :sent
    end

    event :schedule do
      transitions from: :draft, to: :scheduled
    end
  end

  ## Scopes

  # Clear default_scopes set by parent class.
  self.default_scopes = []

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
