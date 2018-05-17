# frozen_string_literal: true

require 'roda'

module BiauHuei
  # Web controller for Credence API
  class App < Roda
    route('auth') do |routing|
      @login_route = '/auth/login'
      
      routing.is 'login' do
        # GET /auth/login
        routing.get do
          view :login
        end

        # POST /auth/login
        routing.post do
          account = AuthenticateAccount.new(App.config).call(
            username: routing.params['username'],
            password: routing.params['password'])
        
          session[:current_account] = account
          flash[:notice] = "Welcome back #{account['username']}!"
          routing.redirect '/'
        rescue StandardError
          flash[:error] = 'Username or password did not match our records'
          routing.redirect @login_route
        end
      end

      routing.on 'logout' do
        routing.get do
          session[:current_account] = nil
          flash[:notice] = 'You are logged out!'
          routing.redirect @login_route
        end
      end
    end
  end
end
