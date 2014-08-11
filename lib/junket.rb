require 'junket/engine'

module Junket
  mattr_accessor :current_user_method
  @current_user_method = :current_user

  # Used to set up Junket from the initializer.
  def self.setup
    yield self
  end
end
