# == Schema Information
#
# Table name: junket_filter_conditions
#
#  id         :integer          not null, primary key
#  filter_id  :integer
#  value      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :junket_filter_condition, class: 'FilterCondition' do
    filter nil
    value 'MyString'
  end
end