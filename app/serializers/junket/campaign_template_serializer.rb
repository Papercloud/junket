class Junket::CampaignTemplateSerializer < ActiveModel::Serializer
  attributes\
    :id,
    :name,
    :send_email,
    :email_subject,
    :email_body,
    :send_sms,
    :sms_body,
    :created_at

  has_many :filter_conditions, embed: :ids, include: true

  def email_subject
    object.prerender(:email_subject, current_junket_user)
  end

  def email_body
    object.prerender(:email_body, current_junket_user)
  end

  def sms_body
    object.prerender(:sms_body, current_junket_user)
  end
end
