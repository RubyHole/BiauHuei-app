# frozen_string_literal: true

require 'roda'

module BiauHuei
  # Web controller for Credence API
  class App < Roda
    route('auth') do |routing|
      def google_oauth_url(config)
        url = config.GOOGLE_OAUTH_URL
        client_id = config.GOOGLE_CLIENT_ID
        scope = config.GOOGLE_SCOPE
        redirect_uri = config.GOOGLE_REDIRECT_URI
        "#{url}?client_id=#{client_id}&scope=#{scope}&response_type=code&redirect_uri=#{redirect_uri}"
      end
      
      def github_oauth_url(config)
        "/auth/login"
      end
      
      
      @login_route = '/auth/login'
      
      routing.is 'login' do
        # GET /auth/login
        routing.get do
          view :login, locals: {
            google_oauth_url: google_oauth_url(App.config),
            github_oauth_url: github_oauth_url(App.config)
          }
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
      
      routing.on 'oauth2callback' do
        routing.is 'google' do
          # GET /auth/oauth2callback/google
          routing.get do
            sso_account = AuthenticateGoogleAccount
                          .new(App.config)
                          .call(routing.params['code'])
            
            current_user = User.new(sso_account['account'], sso_account['auth_token'])
            
            Session.new(SecureSession.new(session)).set_user(current_user)
            flash[:notice] = "Welcome #{current_user.username}!"
            routing.redirect '/'
          rescue StandardError => error
            puts error.inspect
            puts error.backtrace
            flash[:error] = 'Could not sign in using Google'
            routing.redirect @login_route
          end
        end
      
        routing.is 'github' do
          # GET /auth/oauth2callback/github
          routing.get do
            routing.redirect '/'
          end
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
