# frozen_string_literal: true

require 'http'

module BiauHuei
  # Returns all projects belonging to an account
  class GetGroup
    def initialize(config)
      @config = config
    end
  
    def call(user, group_id)
      response = HTTP.auth("Bearer #{user.auth_token}")
                     .get("#{@config.API_URL}/groups/#{group_id}")
      raise StandardError unless response.code == 200
      response.parse
    end
  end
end
