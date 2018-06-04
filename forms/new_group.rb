# frozen_string_literal: true

require 'dry-validation'
require 'ruby-duration'

module BiauHuei
  module Form
    NewGroup = Dry::Validation.Params do
      configure do
        config.messages_file = File.join(__dir__, 'errors/new_group.yml')
        
        def gteql?(r, l)
          l.to_i >= r.to_i
        end
      end
      
      required(:title).filled
      required(:description).filled
      required(:round_interval_days).filled
      required(:round_interval_hours).filled
      required(:round_interval_minutes).filled
      required(:round_interval_seconds).filled
      required(:bidding_duration_days).filled
      required(:bidding_duration_hours).filled
      required(:bidding_duration_minutes).filled
      required(:bidding_duration_seconds).filled
      required(:round_fee).filled
      required(:bidding_upset_price).filled
      required(:members).each(:filled?)
      
      rule(rational_round_fee: [:round_fee]) do |round_fee|
        round_fee.gteql?(0)
      end
      
      rule(rational_bidding_upset_price: [:bidding_upset_price]) do |bidding_upset_price|
        bidding_upset_price.gteql?(0)
      end
    end
  end
end
