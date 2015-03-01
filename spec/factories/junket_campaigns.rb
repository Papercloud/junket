# == Schema Information
#
# Table name: junket_campaigns
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  run_datetime              :datetime
#  owner_id             :integer
#  owner_type           :string(255)
#  action_template_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :junket_campaign, class: 'Junket::Campaign' do
    name 'New Feature'
    send_email true
    send_sms true
    email_subject 'Exciting New Features!'
    email_body 'Hi, check out our new features!'
    sms_body 'We have new features!'
  end
end
