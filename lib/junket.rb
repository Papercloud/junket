require 'junket/engine'

module Junket
  mattr_accessor :authentication_method
  @mattr_accessor = :authenticate_user!

  mattr_accessor :current_user_method
  @current_user_method = :current_user

  mattr_accessor :base_controller
  @base_controller = '::ApplicationController'

  mattr_accessor :targets
  @targets = nil

  mattr_accessor :sms_adapter
  @sms_adapter = nil

  mattr_accessor :sms_from_name
  @sms_from_name = nil

  mattr_accessor :email_adapter
  @email_adapter = nil

  # Used to set up Junket from the initializer.
  def self.setup
    yield self
  end
end
