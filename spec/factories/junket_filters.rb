# == Schema Information
#
# Table name: junket_filters
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  term       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  value_type :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :junket_filter, class: 'Junket::Filter' do
    name 'MyString'
    term 'MyString'
    value_type 'boolean'
  end
end
