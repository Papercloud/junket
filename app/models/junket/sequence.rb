# == Schema Information
#
# Table name: junket_sequences
#
#  id                   :integer          not null, primary key
#  object_id            :integer          not null
#  object_type          :string(255)      not null
#  sequence_template_id :integer          not null
#  owner_id             :integer
#  owner_type           :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

# A history object for a sequences life while following a sequence template... Contains actions with details of the sucess of each event in the sequence.
#
class Junket::Sequence < ActiveRecord::Base
  belongs_to :object, polymorphic: true
  belongs_to :owner, polymorphic: true
  belongs_to :sequence_template
  has_many :actions, dependent: :destroy

  validates_presence_of :sequence_template
  validates_presence_of :object
  # validates_presence_of :owner# lets actually support the case that it could be a now non existant object
  # validate :ower_can_manager_sequence_template

  # protected
  # def ower_can_manager_sequence_template
  # end
end
