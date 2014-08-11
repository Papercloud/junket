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

require 'rails_helper'

module Junket
  RSpec.describe FilterCondition, type: :model do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
