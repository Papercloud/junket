require 'mandrill'

# An adapter for sending email through Mandrill (https://mandrillapp.com)
# TODO: Also support receiving open and click info.
class Junket::Adapters::Email::Mandrill
  # Send an email
  # @param to_email [String] recipient's email address
  # @param to_name [String] recipient's full name
  # @param subject [String] subject line of the email
  # @param body [String] body of the email
  # @param from_name [String] sender name as it should appear to the recipient
  # @param from_email [String] sender email as it should appear to the recipient
  # == Returns:
  # The email's unique ID, for storage so we can track its open and read state.
  def self.send_email(to_email, to_name, subject, body, from_name, from_email)
    return true if Rails.env.test?

    # Assumes your Mandrill API key is stored in ENV['MANDRILL_APIKEY']
    m = Mandrill::API.new
    message = {
      subject: subject,
      html: body,
      auto_text: true,
      to: [
        {
          email: to_email,
          name: to_name
        }
      ],
      from_name: from_name,
      from_email: from_email,
      async: true,
      track_clicks: true,
      track_opens: true
    }
    sending = m.messages.send message
    id = sending.first['_id']
    id
  end
end