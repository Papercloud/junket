require_dependency 'junket/application_controller'

class Junket::CampaignTemplatesController < Junket::ApplicationController
  load_and_authorize_resource

  # All templates I can see
  def index
    respond_with(@campaign_templates)
  end

  # Templates I can edit
  def mine
    respond_with(@campaign_templates.where(access_level: :private))
  end

  # Templates I can't edit
  def public
    respond_with(@campaign_templates.where(access_level: :public))
  end

  # A single template
  def show
    respond_with(@campaign_template)
  end

  # Update a template
  def update
    @campaign_template.update!(campaign_template_params)
    respond_with(@campaign_template)
  end

  # Create a template
  def create
    @campaign_template = Junket::CampaignTemplate.create(campaign_template_params)
    respond_with(@campaign_template)
  end

  private

  def campaign_template_params
    # We allow :access_level, :owner_id and :owner_type as they're validated against ability.rb by CanCan
    params.require(:campaign_template).permit(:id, :name, :send_email, :email_subject, :email_body, :send_sms, :sms_body,
                                              :access_level, :owner_id, :owner_type)
  end
end
