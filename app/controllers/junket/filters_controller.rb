require_dependency 'junket/application_controller'

class Junket::FiltersController < Junket::ApplicationController
  def index
    respond_with(Junket::Filter.order('name ASC').all)
  end
end