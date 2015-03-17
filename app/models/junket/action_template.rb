# == Schema Information
#
# Table name: junket_action_templates
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  campaign_name        :string(255)
#  email_subject        :string(255)
#  email_body           :text
#  sms_body             :text
#  created_at           :datetime
#  updated_at           :datetime
#  type                 :string(255)
#  sequence_template_id :integer
#  run_after_duration   :integer          default(0), not null
#  position             :integer          default(0), not null
#

require 'liquid'

# Represents the content for a mail-out. Can be used as a 'cookie-cutter' for
# multiple campaigns (mail-outs), or represent the content of a single customised mail-out.
# Now has to belong to a sequence template
class Junket::ActionTemplate < ActiveRecord::Base
  attr_accessible :name, :type, :email_body, :sms_body, :run_after_duration, :sequence_template_id, :sequence_template if Rails.version[0] == '3'

  ## Associations
  # Used with 'access_level' for access control. See Junket::Ability.
  belongs_to :sequence_template

  # Pre-defined filters for this campaign for the user's convenience.
  has_many :filter_conditions, dependent: :destroy, foreign_key: :campaign_id

  # Uses of this template. Don't allow deletion of the template if it's used on a
  # action, as the template holds the action's copy.
  has_many :actions, dependent: :destroy

  ## Validations

  validates_presence_of :name, :sequence_template, :run_after_duration

  # with_options if: :send_email?
  #   validates :email_subject, presence: true
  #   validates :email_subject, length: { maximum: 78 }
  #   validates :email_body, presence: true
  # end
  #
  # with_options if: :send_sms?
  #   validates :sms_body, presence: true
  #   validates :sms_body, length: { maximum: 160 }
  # end

  # By default sms and email sending is ok, override in subclass
  validates :send_sms, acceptance: { accept: true }, unless: :send_email?
  validates :send_email, acceptance: { accept: true }, unless: :send_sms?

  validate :valid_liquid_markup?

  acts_as_list

  def create_first_action(object)
    # You can only kick off a sequence for a particular recall once
    return if actions.where(object_id: object.id, object_type: object.class.to_s).count > 0
    create_action_for(object)
  end

  def create_next_action(action)
    return unless action.present?
    # Making assumption here that action templates for a sequence template have
    # position that increments by 1 each time, will bail if the is a gap
    action_template = Junket::ActionTemplate.where('position = (?) AND sequence_template_id = (?)', position + 1, sequence_template_id).first
    action_template.create_action_for(action.object) if action_template.present?
  end

  # Hooks to override
  def should_send_sms?
    true
  end

  def send_email?
    fail 'Please implement in subclass'
  end

  def send_sms?
    fail 'Please implement in subclass'
  end

  def resolve_targets
    fail 'Please implement in subclass'
  end
  # END Hooks to override

  ## Templating

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

  # Run once through Liquid with the sender passed in.
  # Used to swap out things like logos and the sender's name, so they
  # can be shown to the sender at the templating stage.
  # Only applied to access level public templates, as two levels of nested Liquid
  # would suck for users to edit, and could be customised individually anyway.
  def prerender(attribute, viewer)
    return send(attribute) if sequence_template.access_level != 'public'

    Liquid::Template.parse(send(attribute)).render(viewer.class.name.underscore => viewer)
  end

  private

  def create_action_for(object)
    # creates action and schedule it...
    actions.create(run_datetime: run_after_duration.seconds.from_now, object_id: object.id, object_type: object.class.to_s).schedule!
  end
end
