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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :junket_campaign_template, class: 'Junket::CampaignTemplate' do
    name 'New Feature'
    send_email true
    send_sms true
    email_subject 'Exciting New Features!'
    email_body 'Hi, check out our new features!'
    sms_body 'We have new features!'
    access_level :public
  end
end
