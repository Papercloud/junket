require_dependency 'junket/application_controller'

class Junket::CampaignsController < Junket::ApplicationController
  load_and_authorize_resource

  # All my campaigns
  def index
    respond_with(@campaigns)
  end

  # A single campaign
  def show
    respond_with(@campaign)
  end

  # Update a campaign
  def update
    @campaign.update!(campaign_params)
    respond_with(@campaign)
  end

  # Create a campaign
  def create
    @campaign.save
    respond_with(@campaign)
  end

  # Deliver a campaign
  # PUT /campaigns/1/deliver
  def deliver
    @campaign.deliver!
    respond_with(@campaign)
  end

  private

  def campaign_params
    params.require(:campaign).permit(:id, :name, :send_email, :email_subject, :email_body, :send_sms, :sms_body)
  end
end
