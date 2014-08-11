# == Schema Information
#
# Table name: junket_campaign_templates
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  campaign_name :string(255)
#  email_subject :string(255)
#  email_body    :text
#  sms_body      :text
#  send_email    :boolean          default(TRUE)
#  send_sms      :boolean          default(TRUE)
#  access_level  :string(255)      default("private")
#  owner_id      :integer
#  owner_type    :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Junket::CampaignTemplate < ActiveRecord::Base
  ## Associations

  # Used with 'access_level' for access control. See Junket::Ability.
  belongs_to :owner, polymorphic: true

  # Pre-defined filters for this campaign for the user's convenience.
  has_and_belongs_to_many :filter_conditions

  ## Validations

  validates :name, presence: true

  with_options if: :send_email? do
    validates :email_subject, presence: true
    validates :email_subject, length: { maximum: 78 }
    validates :email_body, presence: true
  end

  with_options if: :send_sms? do
    validates :sms_body, presence: true
    validates :sms_body, length: { maximum: 160 }
  end

  validates :send_sms, acceptance: { accept: true }, unless: :send_email?
  validates :send_email, acceptance: { accept: true }, unless: :send_sms?

  validates :access_level, inclusion: { in: [:public, :private] }
end
