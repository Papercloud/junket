# == Schema Information
#
# Table name: junket_sequence_templates
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  owner_id     :integer
#  owner_type   :string(255)
#  access_level :string(255)      default("private"), not null
#  created_at   :datetime
#  updated_at   :datetime
#

# This class is a template of ordered action templates to apply to a recall group.
# It can be used between clinics if it has the right access level.
class Junket::SequenceTemplate < ActiveRecord::Base
  ## Associations
  # Used with 'access_level' for access control. See Junket::Ability.
  belongs_to :owner, polymorphic: true

  has_many :sequence_action_times, dependent: :destroy

  validates :name, presence: true
end
