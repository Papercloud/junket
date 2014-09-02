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

# Represents an instance of a Junket::Filter with a given value,
# used with other FilterConditions to create a targeted recipient list.
# These are defined by users and attached to CampaignTemplates.
class Junket::FilterCondition < ActiveRecord::Base
  belongs_to :filter
  belongs_to :campaign_template

  validates :filter, :campaign_template, presence: true
end
