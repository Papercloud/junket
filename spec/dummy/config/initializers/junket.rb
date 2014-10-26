Junket.setup do |config|

  # Junket will call this to find the current logged in user
  config.current_user_method = :current_user

  config.targets = ->(_campaign) {
    User.unscoped
  }

  config.sms_adapter = 'Junket::Adapters::Sms::SmsBroadcastComAu'
  config.sms_from_name = 'MyCompanyName'

  config.email_adapter = 'Junket::Adapters::Email::Mandrill'

end