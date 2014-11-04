# require_dependency 'junket/application_controller'

# # Mandrill webhooks receiver for email read status
# class Junket::WebhooksController < Junket::ApplicationController
#   include Mandrill::Rails::WebHookProcessor
#   authenticate_with_mandrill_keys! ENV['MANDRILL_WEBHOOK_KEY']

#   def handle_open(_event_payload)
#   end

#   def handle_click(_event_payload)
#   end
# end