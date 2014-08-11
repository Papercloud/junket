# == Schema Information
#
# Table name: junket_filter_conditions
#
#  id         :integer          not null, primary key
#  filter_id  :integer
#  value      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

module Junket
  class FilterCondition < ActiveRecord::Base
    belongs_to :filter
  end
end
