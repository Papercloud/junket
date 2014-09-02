# == Schema Information
#
# Table name: junket_filter_conditions
#
#  id                   :integer          not null, primary key
#  filter_id            :integer
#  campaign_template_id :integer
#  value                :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :junket_filter_condition, class: 'Junket::FilterCondition' do
    association :filter, factory: :junket_filter
    value '1'
  end
end
