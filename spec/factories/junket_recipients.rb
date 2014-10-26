# == Schema Information
#
# Table name: junket_recipients
#
#  id          :integer          not null, primary key
#  target_id   :integer
#  target_type :string(255)
#  campaign_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :junket_recipient, class: 'Recipient' do
    target_id 1
    target_type 'MyString'
    campaign_id 1
  end
end
