class Junket::CampaignSerializer < ActiveModel::Serializer
  attributes\
    :id,
    :name,
    :send_email,
    :email_subject,
    :email_body,
    :send_sms,
    :sms_body
end