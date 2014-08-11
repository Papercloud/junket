require_dependency 'junket/application_controller'

class Junket::CampaignTemplatesController < Junket::ApplicationController
  respond_to :json
  load_and_authorize_resource

  def index
    respond_with(@campaign_templates)
  end

  def mine
    respond_with(@campaign_templates.where(access_level: :private))
  end

  def public
    respond_with(@campaign_templates.where(access_level: :public))
  end

  def show
    respond_with(@campaign_template)
  end
end
