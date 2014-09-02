Junket.setup do |config|

  # Junket will call this to find the current logged in user
  config.current_user_method = :current_user

  config.targets = lambda(_campaign) {
    User.unscoped
  }

end