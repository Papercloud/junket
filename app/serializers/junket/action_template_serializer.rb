class Junket::ActionTemplateSerializer < ActiveModel::Serializer
  attributes\
    :id,
    :name,
    :email_subject,
    :email_body,
    :sms_body,
    :created_at,
    :type,
    :position,
    :run_after_duration

  # has_many :filter_conditions, embed: :ids, include: true
  has_one :sequence_template, embed: :ids, include: false

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
