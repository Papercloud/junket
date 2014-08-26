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

# Represents a single send-out of emails and SMSs to many users.
class Junket::Campaign < ActiveRecord::Base
  # Defines the message content and targeting filters.
  belongs_to :campaign_template

  # Used to record which user sent this campaign.
  belongs_to :owner, polymorphic: true
end
