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
#  type          :string(255)
#  state         :string(255)
#
require 'liquid'

# Represents the content for a mail-out. Can be used as a 'cookie-cutter' for
# multiple campaigns (mail-outs), or represent the content of a single customised mail-out.
class Junket::CampaignTemplate < ActiveRecord::Base
  ## Associations

  # Used with 'access_level' for access control. See Junket::Ability.
  belongs_to :owner, polymorphic: true

  # Pre-defined filters for this campaign for the user's convenience.
  has_many :filter_conditions, dependent: :destroy

  # Uses of this template. Don't allow deletion of the template if it's used on a
  # campaign, as the template holds the campaign's copy.
  has_many :campaigns

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

  validates :access_level, inclusion: { in: %w(public private) }

  validate :valid_liquid_markup?

  ## Scopes

  def self.public
    where(access_level: :public)
  end

  def self.private
    where(access_level: :private)
  end

  # Customer setter for access_level to ensure it's a string, to prevent
  # unintentionally tripping its inclusion validation.
  def access_level=(new_level)
    super new_level.to_s
  end

  # Targeting

  def targets
    base_targets = Junket.targets.call(self)

    # Build Ransack query with all filter conditions
    query = filter_conditions.each_with_object({}) do |condition, q|
      q[condition.filter.term] = condition.value
    end

    base_targets.search(query).result(distinct: true)
  end

  # Templating

  def valid_liquid_markup?
    # Couldn't get error_mode: :warn in Liquid 3.0.0.rc1 to work, so this exception handling
    # approach it is.

    [:email_subject, :email_body, :sms_body].each do |template_method|
      begin
        Liquid::Template.parse(send(template_method))
      rescue Liquid::SyntaxError => e
        errors.add(template_method, e.message)
      end
    end
  end
end
