# == Schema Information
#
# Table name: junket_sequences
#
#  id                          :integer          not null, primary key
#  object_id                   :integer          not null
#  object_type                 :string(255)      not null
#  junket_sequence_template_id :integer          not null
#  created_at                  :datetime
#  updated_at                  :datetime
#

FactoryGirl.define do
  factory :junket_sequence_template, class: 'Junket::SequenceTemplate' do
    sequence(:name) { |n| "S Template #{n}" }
    access_level 'private'
    # association :owner, factory: :clinic
    # owner_type 'Clinic'

    after(:create) do |t, _evaluator|
      # create two action templates.
      2.times do |n|
        FactoryGirl.create(:junket_sequence_action_time, junket_campaign_template: FactoryGirl.create(:junket_campaign_template), sequence_template: t, position: n)
      end
    end
  end

  factory :junket_campaign_template do
    sequence(:name) { |n| "A Template #{n}" }

    send_email true
    send_sms true
    email_subject 'Exciting New Features!'
    email_body 'Hi, check out our new features!'
    sms_body 'We have new features!'

    # type 'RecallSmsActionTemplate'
  end

  factory :junket_action, class: 'Junket::Action' do
    association :sequence
    state 'done'
  end

  factory :junket_sequence_action_time do
    sequence(:duration) { |n| n.minutes }
    sequence(:position) { |n| n }
    association :junket_sequence_template
    association :junket_campaign_template
    junket_campaign_template_type 'RecallSmsActionTemplate'
  end

  factory :recall_sequences do
    association :recall
    association :junket_sequence_template
  end
end
