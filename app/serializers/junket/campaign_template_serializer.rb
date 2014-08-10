module Junket
  class CampaignTemplateSerializer < ActiveModel::Serializer
    attributes :id,
               :send_email, :email_subject, :email_body,
               :send_sms, :sms_body
  end
end
