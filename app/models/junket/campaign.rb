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

module Junket
  class Campaign < ActiveRecord::Base
  end
end
