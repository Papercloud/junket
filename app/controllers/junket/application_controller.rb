# Base class for all Junket controllers.
# Inherits from the host app's ApplicationController
class Junket::ApplicationController < Junket.base_controller.constantize
  responders :json
  respond_to :json

  serialization_scope :current_junket_user

  before_filter :authenticate_junket_user

  def authenticate_junket_user
    method(Junket.authentication_method).class
  end

  def current_ability
    @current_ability ||= Junket::Ability.new(current_junket_user)
  end

  def current_junket_user
    method(Junket.current_user_method).call
  end

  before_filter :default_format_json
  def default_format_json
    request.format = :json unless params[:format]
  end

  rescue_from CanCan::AccessDenied do |error|
    render json: {
      message: error.message
    },     status: :forbidden
  end
end
