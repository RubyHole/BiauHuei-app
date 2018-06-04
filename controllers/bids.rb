# frozen_string_literal: true

require 'roda'

module BiauHuei
  # Web controller for BiauHuei API
  class App < Roda
    route('bids') do |routing|
      @bid_route = "#{@api_root}/bid"
      
      routing.is 'new' do
        # Post /bids/new
        routing.post do
          
          unless @current_user.logged_in?
            routing.redirect '/auth/login'
          end
          
          new_bid_data = Form::NewBid.call(routing.params)
          
          if new_bid_data.failure?
            flash[:error] = Form.validation_errors(new_bid_data)
            routing.redirect "/groups/#{new_bid_data[:group_id]}"
          end
          
          CreateNewBid.new(App.config).call(@current_user, new_bid_data)
          
          flash[:notice] = 'New bid created'
          routing.redirect "/groups/#{new_bid_data[:group_id]}"
        rescue StandardError
          flash[:error] = 'Invalid Request'
          routing.redirect '/'
        end
      end
      
    end
  end
end
