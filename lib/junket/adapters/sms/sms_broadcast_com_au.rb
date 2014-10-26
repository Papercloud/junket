# An adapter for sending an SMS through www.smsbroadcast.com.au
class Junket::Adapters::Sms::SmsBroadcastComAu
  # Send an SMS
  # @param mobile_number [String] the recipient's mobile number
  # @param message [String] the SMS content
  # @param from [String] the name shown as the sender to the recipient
  # == Returns:
  # true if the SMS sent successfully, raises an exception if it didn't.
  def self.send_sms(mobile, message, from)
    return true if Rails.env.test?

    # Don't send in dev.
    if Rails.env.development?
      puts "\n\n\n\n\n\n\n\n\nSENDING SMS to #{mobile}, with message: #{message}\n\n\n\n\n\n\n"
      return true
    end

    params = {
      username: ENV['SMS_USER'],
      password: ENV['SMS_PWD'],
      message: message,
      to: mobile,
      from: from,
      maxsplit: 5 # Split into max 5 messages if we go over th 160 char limit
    }
    url = URI.parse(['https://www.smsbroadcast.com.au/api-adv.php', params.to_query].join('?'))

    require 'net/http'
    require 'net/https'

    request = Net::HTTP::Get.new(url.to_s)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.start do |inner_http|
      inner_http.request(request)
    end

    code = response.body.split(':')
    status = code.fetch(0, nil)
    if status == 'OK'
      # Succeeded
      return true

    # Raise errors if we fail so a) we'll get alerted by an exception monitor and can investigate
    # and b) it'll get retried by Sidekiq.
    elsif status == 'BAD'
      fail "SMS REGISTRATION to #{mobile} FAILED: #{code.fetch(2, 'No message')}"
    elsif status == 'ERROR'
      fail "SMS REGISTRATION to #{mobile} FAILED: #{code.fetch(1, 'No message')}"
    else
      fail "SMS FAILED FOR SOME OTHER REASON: #{response.body}"
    end
    false
  end
end