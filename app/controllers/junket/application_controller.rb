# Base class for all Junket controllers.
# Inherits from the host app's ApplicationController
class Junket::ApplicationController < ::ApplicationController
  def current_ability
    @current_ability ||= Junket::Ability.new(current_user)
  end
end
