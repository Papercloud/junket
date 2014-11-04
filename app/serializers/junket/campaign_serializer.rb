class Junket::CampaignSerializer < ActiveModel::Serializer
  attributes\
    :id,
    :name,
    :send_email,
    :email_subject,
    :email_body,
    :send_sms,
    :sms_body,
    :state,
    :recipients_count,
    :created_at,
    :send_at

  has_many :filter_conditions, embed: :ids, include: false

  def recipients_count
    object.recipients.count
  end
end