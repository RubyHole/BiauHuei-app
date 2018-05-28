# frozen_string_literal: true

require 'http'

module BiauHuei
  # Returns all projects belonging to an account
  class GetGroups
    def initialize(config)
      @config = config
    end
  
    def call(user)
      response = HTTP.auth("Bearer #{user.auth_token}")
                     .get("#{@config.API_URL}/groups")
      raise StandardError unless response.code == 200
      response.parse
    end
  end
end
