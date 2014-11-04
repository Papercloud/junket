# == Schema Information
#
# Table name: junket_recipients
#
#  id                   :integer          not null, primary key
#  target_id            :integer
#  target_type          :string(255)
#  campaign_id          :integer
#  created_at           :datetime
#  updated_at           :datetime
#  email_third_party_id :string(255)
#

class Junket::Recipient < ActiveRecord::Base
  # An object in the parent app to which the campaign was sent. Usually something like 'User'.
  belongs_to :target, polymorphic: true

  # The campaign which was sent.
  belongs_to :campaign
end
