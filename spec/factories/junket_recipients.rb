# == Schema Information
#
# Table name: junket_recipients
#
#  id                   :integer          not null, primary key
#  target_id            :integer
#  target_type          :string(255)
#  action_id            :integer
#  created_at           :datetime
#  updated_at           :datetime
#  email_third_party_id :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :junket_recipient, class: 'Recipient' do
    target_id 1
    target_type 'MyString'
    campaign_id 1
  end
end
