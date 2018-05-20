# frozen_string_literal: true

require 'http'

# Returns an authenticated user, or nil
class CreateAccount
  class InvalidAccount < StandardError; end

  def initialize(config)
    @config = config
  end

  def call(email:, username:, password:)
    message = { email: email,
                username: username,
                password: password }

    response = HTTP.post(
      "#{@config.API_URL}/account/new",
      json: message
    )

    raise InvalidAccount unless response.code == 201
  end
end
