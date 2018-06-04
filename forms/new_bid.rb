# frozen_string_literal: true

require 'dry-validation'

module BiauHuei
  module Form
    NewBid = Dry::Validation.Params do
      configure do
        config.messages_file = File.join(__dir__, 'errors/new_bid.yml')
        
        def gteql?(r, l)
          l.to_i >= r.to_i
        end
      end
      
      required(:group_id).filled
      required(:bid_price).filled
      required(:bidding_upset_price).filled
      
      rule(rational_bid_price: %i[bid_price bidding_upset_price]) do |bid_price, bidding_upset_price|
        bid_price.gteql?(bidding_upset_price)
      end
    end
  end
end
