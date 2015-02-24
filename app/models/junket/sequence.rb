# == Schema Information
#
# Table name: junket_sequences
#
#  id                          :integer          not null, primary key
#  object_id                   :integer          not null
#  object_type                 :string(255)      not null
#  junket_sequence_template_id :integer          not null
#  created_at                  :datetime
#  updated_at                  :datetime
#

# A history object for a sequences life while following a sequence template... Contains actions with details of the sucess of each event in the sequence.
#
class Junket::Sequence < ActiveRecord::Base
  attr_accessible :name, :access_level
  belongs_to :object, polymorphic: true
  belongs_to :sequence_template
  has_many :actions, dependent: :destroy
end
