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

class Junket::Filter < ActiveRecord::Base
  validates :name, :term, :value_type, presence: true
  validates :value_type, inclusion: { in: %w( boolean string integer ) }
end
