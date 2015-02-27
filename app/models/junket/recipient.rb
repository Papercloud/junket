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
  # An object in the parent app on which the action was run. Usually something like 'User'.
  belongs_to :target, polymorphic: true

  # The action which was run.
  belongs_to :action
end
