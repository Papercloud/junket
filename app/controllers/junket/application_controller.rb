# Base class for all Junket controllers.
# Inherits from the host app's ApplicationController
class Junket::ApplicationController < ::ApplicationController
  def current_ability
    @current_ability ||= Junket::Ability.new(current_user)
  end

  before_filter :default_format_json
  def default_format_json
    request.format = :json unless params[:format]
  end
end
