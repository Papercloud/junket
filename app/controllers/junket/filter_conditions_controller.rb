require_dependency 'junket/application_controller'

class Junket::FilterConditionsController < Junket::ApplicationController
  load_and_authorize_resource

  def index
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
    @filter_condition.update(filter_condition_params)
    respond_with(@filter_condition)
  end

  def destroy
    @filter_condition.delete
    respond_with(@filter_condition)
  end

  private

  def filter_condition_params
    params.require(:filter_condition).permit(:id, :value, :filter_id, :campaign_template_id)
  end
end