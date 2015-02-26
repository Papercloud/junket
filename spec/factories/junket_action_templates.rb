# == Schema Information
#
# Table name: junket_action_templates
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  campaign_name        :string(255)
#  email_subject        :string(255)
#  email_body           :text
#  sms_body             :text
#  created_at           :datetime
#  updated_at           :datetime
#  type                 :string(255)
#  sequence_template_id :integer
#  run_after_duration   :integer          default(0), not null
#  position             :integer          default(0), not null
#

FactoryGirl.define do

  factory :junket_action_template, class: 'TestActionTemplateSubclass' do
    sequence(:name) { |n| "A Template #{n}" }
    run_after_duration 10.minutes
    position 0
    send_email true
    send_sms true
    email_subject 'Exciting New Features!'
    email_body 'Hi, check out our new features!'
    sms_body 'We have new features!'
    association :sequence_template, factory: :junket_sequence_template

    type 'TestActionTemplateSubclass'
  end

end
