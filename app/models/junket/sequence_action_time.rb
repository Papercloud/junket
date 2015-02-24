# == Schema Information
#
# Table name: junket_sequence_action_times
#
#  id                     :integer          not null, primary key
#  duration               :integer          not null
#  position               :integer          default(0), not null
#  sequence_template_id   :integer          not null
#  campaign_template_id   :integer          not null
#  campaign_template_type :string(255)      not null
#  created_at             :datetime
#  updated_at             :datetime
#

# Joining a campaign_template to its sequence_template at a certain time.
# This class is for knowing when each action will execute in a sequence template and in what order.
class Junket::SequenceActionTime < ActiveRecord::Base
  # attr_accessible :duration, :position

  belongs_to :sequence_template
  belongs_to :campaign_template

  acts_as_list
end
