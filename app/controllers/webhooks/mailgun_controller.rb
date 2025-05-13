require 'openssl'

module Webhooks
  class MailgunController < ActionController::Metal
    def failed
      set_known_statuses

      return unless status == 200

      person&.update_column(:fake_email, true)
    end

    def complained
      set_known_statuses

      return unless status == 200

      person&.update_column(:spam_complain, true)
    end

    private

    def event
      params.dig('event-data', 'event')
    end

    def recipient
      params.dig('event-data', 'recipient')
    end

    def person
      Person.find_by(email: recipient)
    end

    def signature_valid?
      signature = params['signature']

      return false if signature.blank?
      return false if signature['timestamp'].blank? || signature['token'].blank? || signature['signature'].blank?

      digest = OpenSSL::Digest.new('SHA256')
      data = "#{signature['timestamp']}#{signature['token']}"

      signature['signature'] == OpenSSL::HMAC.hexdigest(digest, EVN["MAILGUN_SIGNING_KEY"], data)
    end

    def set_known_statuses
      return self.status = 401 unless signature_valid?

      self.status = 406 unless event == params[:action]
    end
  end
end
