# frozen_string_literal: true

require 'http'

# Returns an authenticated user, or nil
class CreateAccount
  # Error for inability of API to create account
  class InvalidAccount < StandardError
    def message
      'This account can no longer be created: please start again'
    end
  end

  def initialize(config)
    @config = config
  end

  # Create account with account_data hash: email, username, password
  def call(account_data)
    response = HTTP.post(
      "#{@config.API_URL}/accounts/new",
      json: account_data
    )

    raise InvalidAccount unless response.code == 201
  end
end
