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
            JsonRequestBody.symbolize(routing.params)
          )
        
          SecureSession.new(session).set(:current_account, account)
          flash[:notice] = "Welcome back #{account['username']}!"
          routing.redirect '/'
        rescue StandardError
          flash[:error] = 'Username or password did not match our records'
          routing.redirect @login_route
        end
      end

      routing.is 'logout' do
        routing.get do
          SecureSession.new(session).delete(:current_account)
          flash[:notice] = 'You are logged out!'
          routing.redirect @login_route
        end
      end
      
      @register_route = '/auth/register'
      routing.is 'register' do
        routing.get do
          view :register
        end

        routing.post do
          account_data = JsonRequestBody.symbolize(routing.params)
          CreateAccount.new(App.config).call(account_data)

          flash[:notice] = 'Please login with your new account information'
          routing.redirect '/auth/login'
        rescue StandardError => error
          puts "ERROR CREATING ACCOUNT: #{error.inspect}"
          puts error.backtrace
          flash[:error] = 'Could not create account'
          routing.redirect @register_route
        end
      end
    end
  end
end
