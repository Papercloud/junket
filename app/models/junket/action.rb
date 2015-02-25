# == Schema Information
#
# Table name: junket_actions
#
#  id                   :integer          not null, primary key
#  sequence_id          :integer          not null
#  campaign_template_id :integer          not null
#  state                :string(255)      not null
#  send_at              :datetime         not null
#  created_at           :datetime
#  updated_at           :datetime
#

# Each event in a sequence, this has details of low level events such as an sms being sent and when.
class Junket::Action < ActiveRecord::Base
  # attr_accessible :state
  belongs_to :sequence
  belongs_to :campaign_template

  validates_presence_of :send_at, :campaign_template, :sequence

  # State machine to manage waiting/scheduled/sent state.
  include AASM
  aasm column: :state do
    state :waiting, initial: true
    state :scheduled, before_enter: :schedule_delivery
    state :sent, before_enter: :send_everything

    event :deliver do
      transitions from: :scheduled, to: :sent
    end

    event :schedule do
      transitions from: :waiting, to: :scheduled
    end
  end
end
