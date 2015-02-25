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
    # association :owner, factory: :clinic
    # owner_type 'Clinic'

    after(:create) do |t, _evaluator|
      # create two action templates.
      2.times do |n|
        FactoryGirl.create(:junket_sequence_action_time, campaign_template: FactoryGirl.create(:junket_campaign_template), sequence_template: t, position: n)
      end
    end
  end

  factory :junket_campaign_template, class: 'Junket::CampaignTemplate' do
    sequence(:name) { |n| "A Template #{n}" }

    send_email true
    send_sms true
    email_subject 'Exciting New Features!'
    email_body 'Hi, check out our new features!'
    sms_body 'We have new features!'

    # type 'RecallSmsActionTemplate'
  end

  factory :junket_action, class: 'Junket::Action' do
    association :sequence, factory: :junket_sequence
    association :campaign_template, factory: :junket_campaign_template
    state 'scheduled'
  end

  factory :junket_sequence_action_time, class: 'Junket::SequenceActionTime' do
    sequence(:duration) { |n| n.minutes }
    sequence(:position) { |n| n }
    association :sequence_template, factory: :junket_sequence_template
    association :campaign_template, factory: :junket_campaign_template
    campaign_template_type 'RecallSmsActionTemplate'
  end

  factory :junket_sequence, class: 'Junket::Sequence' do
    object { User.create(email: 'a@a.com') }
    owner { User.create(email: 'a@a.com') }

    association :sequence_template, factory: :junket_sequence_template

    after(:create) do |seq, _evaluator|
      2.times do
        FactoryGirl.create(:junket_action, sequence: seq)
      end
    end
  end
end
