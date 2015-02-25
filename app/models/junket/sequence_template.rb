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

  validates_presence_of :name, :owner_id, :owner_type

  # Customer setter for access_level to ensure it's a string, to prevent
  # unintentionally tripping its inclusion validation.
  def access_level=(new_level)
    super new_level.to_s
  end
  validates :access_level, inclusion: { in: %w(public private) }

  def sequence_action_times
    super.order('position')
  end
end
