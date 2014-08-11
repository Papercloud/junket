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
