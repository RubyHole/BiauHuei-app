# frozen_string_literal: true

require 'http'
require 'ruby-duration'

# Create a new group
class CreateNewGroup
  # Error for illegal round_interval and bidding_duration
  class IllegalRoundIntervalBiddingDuration < StandardError
    def message
      '"round_interval" or "bidding_duration" should be larger than 0, and "round_interval" should be larger than "bidding_duration"'
    end
  end
  
  def initialize(config)
    @config = config
  end

  # Create new group with new_group_data hash:
  # title,
  # description,
  # round_interval_days,
  # round_interval_hours,
  # round_interval_minutes,
  # round_interval_seconds,
  # bidding_duration_days,
  # bidding_duration_hours,
  # bidding_duration_minutes,
  # bidding_duration_seconds
  # round_fee,
  # bidding_upset_price,
  # members
  def call(user, new_group_data)
    response = HTTP.auth("Bearer #{user.auth_token}")
                   .post("#{@config.API_URL}/groups/new",
                         json: reformulate(new_group_data))
    raise StandardError unless response.code == 201
    response.parse
  end
  
  def reformulate(new_group_data)
    round_interval = Duration.new(
      :days => new_group_data[:round_interval_days],
      :hours => new_group_data[:round_interval_hours],
      :minutes => new_group_data[:round_interval_minutes],
      :seconds => new_group_data[:round_interval_seconds],
    )
    
    bidding_duration = Duration.new(
      :days => new_group_data[:bidding_duration_days],
      :hours => new_group_data[:bidding_duration_hours],
      :minutes => new_group_data[:bidding_duration_minutes],
      :seconds => new_group_data[:bidding_duration_seconds],
    )
    
    raise IllegalRoundIntervalBiddingDuration unless round_interval.total > 0
    raise IllegalRoundIntervalBiddingDuration unless bidding_duration.total > 0
    raise IllegalRoundIntervalBiddingDuration unless round_interval.total >= bidding_duration.total
    
    {
      title: new_group_data[:title],
      description: new_group_data[:description],
      round_interval: round_interval.total,
      round_fee: new_group_data[:round_fee].to_i,
      bidding_duration: bidding_duration.total,
      bidding_upset_price: new_group_data[:bidding_upset_price].to_i,
      members: new_group_data[:members],
    }
  end
end
