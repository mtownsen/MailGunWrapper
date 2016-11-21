require 'spec_helper'

describe 'MailgunWrapper::MailGun' do
  before do
    @domain = 'sandbox91dc6a61c5474205a67562a073f2f920.mailgun.org'
    @mailgun = MailgunWrapper::MailGun.new(ENV['MAILGUN_API_KEY'], @domain)
  end

  describe ':send_message_suppressed' do
    it 'attempts to email a suppressed address' do
      res = @mailgun.send_message('Test Subject', 'Test Body', '12345', 'thunderfan1984@gmail.com')
      expect(res).to eq('email suppressed')
    end
  end

  describe ':send_message' do
    it 'sends a email to given email_address' do
      res = @mailgun.send_message('Test Subject', 'Test Body', '12345', 'matthewtownsen@gmail.com')
      expect(res.code).to eq(200)
    end
  end

  describe ':list_emails' do
    it 'show list sent emails for given email_address' do
      res = @mailgun.list_emails('matthewtownsen@gmail.com')
      expect(res.code).to eq(200)
    end
  end

  describe ':precheck' do
    it 'it should check the email provided for suppressions' do
      res = @mailgun.email_precheck('thunderfan1984@gmail.com')
      expect(res).to eq(true)
    end
  end
end
