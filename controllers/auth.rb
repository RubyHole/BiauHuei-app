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
          credentials = Form::LoginCredentials.call(routing.params)
          
          if credentials.failure?
            flash[:error] = 'Please enter both username and password'
            routing.redirect @login_route
          end

          authenticated = AuthenticateAccount.new(App.config).call(credentials)
          current_user = User.new(authenticated['account'],
                                  authenticated['auth_token'])
          
          Session.new(SecureSession.new(session)).set_user(current_user)
          flash[:notice] = "Welcome back #{current_user.username}!"
          routing.redirect '/'
        rescue StandardError
          flash[:error] = 'Username or password did not match our records'
          routing.redirect @login_route
        end
      end

      routing.is 'logout' do
        # GET /auth/logout
        routing.get do
          Session.new(SecureSession.new(session)).delete
          flash[:notice] = 'You are logged out!'
          routing.redirect @login_route
        end
      end
      
      @register_route = '/auth/register'
      routing.is 'register' do
        # GET /auth/register
        routing.get do
          view :register
        end
        
        # POST /auth/register
        routing.post do
          registration = Form::Registration.call(routing.params)
          
          if registration.failure?
            flash[:error] = Form.validation_errors(registration)
            routing.redirect @register_route
          end
          
          VerifyRegistration.new(App.config).call(registration.to_h)
          
          flash[:notice] = 'Please check your email for a verification link'
          routing.redirect '/'
        rescue StandardError
          flash[:error] = 'Please check username and email'
          routing.redirect @register_route
        end
      end
      
      routing.on 'register' do
        # GET /auth/register/[registration_token]
        routing.get(String) do |registration_token|
          flash.now[:notice] = 'Email Verified! Please choose a new password'
          new_account = SecureMessage.decrypt(registration_token)
          view :register_confirm,
               locals: { new_account: new_account,
                         registration_token: registration_token }
        end
      end
    end
  end
end
