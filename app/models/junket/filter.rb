# == Schema Information
#
# Table name: junket_filters
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  term       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  value_type :string(255)
#

# Represents a property we can filter by to create a targeted recipient list.
class Junket::Filter < ActiveRecord::Base
  validates :name, :term, :value_type, presence: true
  validates :value_type, inclusion: { in: %w( boolean string integer ) }

  # This association is just for clean-up, as each condition would apply to
  # a different campaign.
  has_many :filter_conditions, dependent: :destroy
end
