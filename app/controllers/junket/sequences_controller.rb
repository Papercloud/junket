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

  # Create a campaign
  def create
    if @sequence.save
      respond_with(sequence: @sequence)
    else
      respond_with(@sequence.errors, status: :unprocessable_entity)
    end
  end

  # GET /campaigns/1/targets_count
  def targets_count
    respond_with(@sequence.targets_count)
  end

  private

  def sequence_params
    params.require(:sequence).permit(:id, :object_id, :object_type, :sequence_template_id).merge('owner_id' => current_junket_user.id, 'owner_type' => current_junket_user.class.to_s)
  end
end
