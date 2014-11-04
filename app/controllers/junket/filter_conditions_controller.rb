require_dependency 'junket/application_controller'

class Junket::FilterConditionsController < Junket::ApplicationController
  load_and_authorize_resource

  def index
    @filter_conditions = @filter_conditions.where('junket_filter_conditions.id IN (?)', params[:ids]) if params[:ids]
    respond_with(@filter_conditions)
  end

  def show
    respond_with(@filter_condition)
  end

  def create
    @filter_condition.save
    respond_with(@filter_condition)
  end

  def update
    @filter_condition.update_attributes(filter_condition_params)
    respond_with(@filter_condition)
  end

  def destroy
    @filter_condition.delete
    respond_with(@filter_condition)
  end

  private

  def filter_condition_params
    params.require(:filter_condition).permit(:id, :value, :filter_id, :campaign_id)
  end
end