# == Schema Information
#
# Table name: junket_campaigns
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  send_at              :datetime
#  owner_id             :integer
#  owner_type           :string(255)
#  campaign_template_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :junket_campaign, class: 'Campaign' do
    name 'MyString'
    send_at '2014-08-11 14:39:20'
    owner_id 1
    owner_type 'MyString'
    campaign_template_id 1
  end
end
