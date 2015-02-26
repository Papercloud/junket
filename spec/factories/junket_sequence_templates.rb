# == Schema Information
#
# Table name: junket_sequence_templates
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  owner_id     :integer
#  owner_type   :string(255)
#  access_level :string(255)      default("private"), not null
#  created_at   :datetime
#  updated_at   :datetime
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
        t.action_templates.create(attributes_for(:junket_action_template).merge(sequence_template: t, position: n))
      end
    end
  end
end
