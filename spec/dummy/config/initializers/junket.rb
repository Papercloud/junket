Junket.setup do |config|

  # All Junket controllers will inherit from this class
  config.base_controller = '::ApplicationController'

  # Junket will call this in a before filter to ensure there is a logged in user
  config.authentication_method = nil

  # Junket will call this to find the current logged in user
  config.current_user_method = :current_user

  config.targets = ->(_campaign) {
    User.unscoped
  }

  config.sms_adapter = 'Junket::Adapters::Sms::SmsBroadcastComAu'
  config.sms_from_name = 'MyCompanyName'

  config.email_adapter = 'Junket::Adapters::Email::Mandrill'

end