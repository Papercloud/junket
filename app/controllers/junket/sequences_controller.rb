require_dependency 'junket/application_controller'

class Junket::SequencesController < Junket::ApplicationController
  load_and_authorize_resource

  # All my campaigns
  def index
    respond_with(@sequences.order('created_at DESC'))
  end

  # A single campaign
  def show
    respond_with(sequence: @sequence)
  end

  # Update a campaign
  def update
    @campaign.update_attributes(sequence_params)
    respond_with(sequence: @campaign)
  end

  # Create a campaign
  def create
    @sequence.save
    respond_with(sequence: @sequence)
  end

  # Destroy a campaign
  def destroy
    @sequence.destroy
    respond_with(@sequence)
  end

  # Deliver a campaign
  # PUT /campaigns/1/schedule
  def schedule
    @sequence.schedule!
    respond_with(sequence: @sequence)
  end

  # GET /campaigns/1/targets_count
  def targets_count
    respond_with(@sequence.targets_count)
  end

  private

  def sequence_params
    p = params.require(:sequence).permit(:id, :object_id, :object_type, :sequence_template_id)
    p['owner_id'] = current_user.id
    p['owner_type'] = current_user.class.to_s
    p
  end
end
