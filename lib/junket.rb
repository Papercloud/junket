require 'junket/engine'

module Junket
  mattr_accessor :current_user_method
  @current_user_method = :current_user

  mattr_accessor :targets
  @targets = nil

  # Used to set up Junket from the initializer.
  def self.setup
    yield self
  end
end
