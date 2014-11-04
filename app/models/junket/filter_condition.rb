# == Schema Information
#
# Table name: junket_filter_conditions
#
#  id          :integer          not null, primary key
#  filter_id   :integer
#  campaign_id :integer
#  value       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

# Represents an instance of a Junket::Filter with a given value,
# used with other FilterConditions to create a targeted recipient list.
# These are defined by users and attached to CampaignTemplates.
class Junket::FilterCondition < ActiveRecord::Base
  belongs_to :filter

  # Two relationships as Campaign inherits with STI from CampaignTemplate.
  belongs_to :campaign, class_name: 'Junket::Campaign'
  belongs_to :campaign_template, class_name: 'Junket::CampaignTemplate', foreign_key: :campaign_id

  validates :filter, :campaign_id, presence: true
end
