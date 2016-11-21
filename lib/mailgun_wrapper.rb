require "mailgun_wrapper/version"
require 'rest-client'

module MailgunWrapper
  class MailGun
    def initialize(api_key, domain)
      @api_key = api_key
      @domain = domain
    end

    def send_message(subject, text, campain_id, email_address)
      if !email_precheck(email_address)
        #email passed process messae
        RestClient.post base_url("messages"),
          :from => "matthewtownsen@gmail.com",
          :to => email_address,
          :subject => subject,
          :text => text,
          "o:campaign" => campain_id
      else
        #email has been suppressed. notify user.
        return 'email suppressed'
      end

    end

    def email_precheck(email_address)
      begin
        res = RestClient.get(base_url("bounces/" + email_address))
        return true
      rescue RestClient::ExceptionWithResponse => e
        return false
      end
    end

    def list_emails(email_address)
      RestClient.get base_url("events"),
         :params => {
          :"event" => 'delivered',
          :'recipient' => email_address
         }
    end

    private

    def base_url(method)
      "https://api:"+@api_key+"@api.mailgun.net/v3/" + @domain + "/" + method
    end

  end
end
