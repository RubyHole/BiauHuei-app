# frozen_string_literal: true

require 'http'

module BiauHuei
  # Returns an authenticated user, or nil
  class VerifyRegistration
    class RegistrationVerificationError < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(registration_data)
      registration_token = SecureMessage.encrypt(registration_data)
      registration_data[:verification_url] =
        "#{@config.APP_URL}/auth/register/#{registration_token}"
      signed_registration = SecureMessage.sign(registration_data)
      
      response = HTTP.post("#{@config.API_URL}/auth/register",
                           json: signed_registration)

      raise(RegistrationVerificationError) unless response.code == 201
      response.parse
    end
  end
end
