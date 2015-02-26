# == Schema Information
#
# Table name: junket_sequences
#
#  id                   :integer          not null, primary key
#  object_id            :integer          not null
#  object_type          :string(255)      not null
#  sequence_template_id :integer          not null
#  owner_id             :integer
#  owner_type           :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

FactoryGirl.define do
  factory :junket_sequence_template, class: 'Junket::SequenceTemplate' do
    sequence(:name) { |n| "S Template #{n}" }
    access_level 'private'
    owner_id 1
    owner_type 'OpenStruct'

    after(:create) do |t, _evaluator|
      # create two action templates.
      2.times do |n|
        FactoryGirl.create(:junket_sequence_action_time, action_template: FactoryGirl.create(:junket_action_template), sequence_template: t, position: n)
      end
    end
  end

  factory :junket_action_template, class: 'Junket::ActionTemplate' do
    sequence(:name) { |n| "A Template #{n}" }

    send_email true
    send_sms true
    email_subject 'Exciting New Features!'
    email_body 'Hi, check out our new features!'
    sms_body 'We have new features!'

    # type 'RecallSmsActionTemplate'
  end

  factory :junket_action, class: 'Junket::Action' do
    send_at 10.minutes.from_now
    association :sequence, factory: :junket_sequence
    association :action_template, factory: :junket_action_template
    state 'scheduled'
  end

  factory :junket_sequence_action_time, class: 'Junket::SequenceActionTime' do
    duration_since_previous 10.minutes
    association :sequence_template, factory: :junket_sequence_template
    association :action_template, factory: :junket_action_template
    action_template_type 'RecallSmsActionTemplate'
  end

  factory :junket_sequence, class: 'Junket::Sequence' do
    object { User.create(email: 'a@a.com') }
    owner { User.create(email: 'a@a.com') }
    association :sequence_template, factory: :junket_sequence_template
  end
end
