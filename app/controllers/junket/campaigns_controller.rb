require_dependency 'junket/application_controller'

class Junket::CampaignsController < Junket::ApplicationController
  load_and_authorize_resource

  # All my campaigns
  def index
    respond_with(@campaigns.order('created_at DESC'))
  end

  # A single campaign
  def show
    respond_with(@campaign)
  end

  # Update a campaign
  def update
    @campaign.update_attributes(campaign_params)
    respond_with(@campaign)
  end

  # Create a campaign
  def create
    @campaign.save
    respond_with(@campaign)
  end

  # Destroy a campaign
  def destroy
    @campaign.destroy
    respond_with(@campaign)
  end

  # Deliver a campaign
  # PUT /campaigns/1/schedule
  def schedule
    @campaign.schedule!
    respond_with(@campaign)
  end

  # GET /campaigns/1/targets_count
  def targets_count
    respond_with(@campaign.targets_count)
  end

  private

  def campaign_params
    params.require(:campaign).permit(:id, :name, :send_email, :email_subject, :email_body, :send_sms, :sms_body, :send_at)
  end
end
