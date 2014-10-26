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
#  send_email    :boolean          default(TRUE)
#  send_sms      :boolean          default(TRUE)
#  access_level  :string(255)      default("private")
#  owner_id      :integer
#  owner_type    :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  type          :string(255)
#  state         :string(255)
#

# Represents a single send-out of emails and SMSs to many users.
class Junket::Campaign < Junket::CampaignTemplate
  has_many :recipients, dependent: :delete_all

  # State machine to manage draft/scheduled/sent state.
  include AASM
  aasm column: :state do
    state :draft, initial: true
    state :sent, before_enter: :send_everything

    event :deliver do
      transitions from: :draft, to: :sent
    end
  end

  private

  # Do the work of sending out a campaign.
  # Don't call this directly, use the 'send' state machine event instead.
  def send_everything
    targets.each do |target|
      # TODO: Put each recipient on another job to keep per-job execution time low?
      recipient = Junket::Recipient.new(target: target, campaign: self)
      recipient.save!

      send_sms_to(recipient) if self.send_sms?
      send_email_to(recipient) if self.send_email?
    end
  end

  # Sends the campaign's SMS body to a recipient.
  def send_sms_to(recipient)
    if Junket.sms_adapter && Junket.sms_from_name
      # TODO: DSL for declaring on a target class which property to use for its mobile number.
      # TODO: DSL for declaring which of the owner's properties becomes the 'sms_from_name': it shouldn't be defined globally.
      Junket.sms_adapter.constantize.send_sms(recipient.target.mobile, sms_body, Junket.sms_from_name)
    else
      fail 'Please set config.sms_adapter and config.sms_from_name in your Junket initialiser'
    end
  end

  # Sends the campaigns email to a recipient.
  def send_email_to(recipient)
    email_id = Junket.email_adapter.constantize.send_email(
      # TODO: Need to define this interface, or have a DSL to declare it.
      recipient.target.email,
      recipient.target.full_name,
      email_subject,
      # TODO: Apply templating.
      email_body,
      # TODO: Need to define campaign owner interface for sender name and email.
      owner.name,
      owner.email)

    # Save the email's unique identifier, so we can receive a webhook to tell when it has been opened or clicked.
    recipient.email_third_party_id = email_id
    recipient.save!
  end
end
