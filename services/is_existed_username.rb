# frozen_string_literal: true

require 'http'

# Check whether a username is existed
class IsExistedUsername
  def initialize(config)
    @config = config
  end

  # Check whether a username is existed
  def call(user, username)
    response = HTTP.auth("Bearer #{user.auth_token}")
                   .get("#{@config.API_URL}/accounts/existed/#{username}")
    raise StandardError unless response.code == 200
    response.parse
  end
end
