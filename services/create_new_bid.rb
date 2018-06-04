# frozen_string_literal: true

require 'http'

# Create a new bid
class CreateNewBid
  def initialize(config)
    @config = config
  end

  # Create new bid with new_bid_data hash: group_id, username, password
  def call(user, new_bid_data)
    response = HTTP.auth("Bearer #{user.auth_token}")
                   .post("#{@config.API_URL}/bid/new",
                         json: { 'group_id': new_bid_data[:group_id].to_i,
                                 'bid_price': new_bid_data[:bid_price].to_i })
    raise StandardError unless response.code == 201
    response.parse
  end
end
