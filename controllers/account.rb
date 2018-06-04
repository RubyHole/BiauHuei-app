# frozen_string_literal: true

require 'roda'

module BiauHuei
  # Web controller for BiauHuei API
  class App < Roda
    plugin :halt
    
    # rubocop:disable Metrics/BlockLength
    route('account') do |routing|
      routing.on do
        # GET /account/[username]
        routing.get String do |username|
          if @current_user && @current_user.username == username
            view :account, locals: { current_user: @current_user }
          else
            routing.redirect '/auth/login'
          end
        end
        
        # POST /account/[registration_token] -- finishes registration process
        routing.post String do |registration_token|
          passwords = Form::Passwords.call(routing.params)
          if passwords.failure?
            flash[:error] = Form.message_values(passwords)
            routing.redirect "/account/#{registration_token}"
          end

          new_account = SecureMessage.decrypt(registration_token)
          CreateAccount.new(App.config).call(
            email: new_account['email'],
            username: new_account['username'],
            password: routing.params['password']
          )
          flash[:notice] = 'Account created! Please login'
          routing.redirect '/auth/login'
        rescue CreateAccount::InvalidAccount => error
          flash[:error] = error.message
          routing.redirect '/auth/register'
        rescue StandardError => error
          flash[:error] = error.message
          routing.redirect(
            "/auth/register/#{registration_token}"
          )
        end
        
        routing.on 'existed' do
          # GET /account/existed/[username]
          routing.get String do |username|
            raise unless @current_user.logged_in?
            response_body = IsExistedUsername.new(App.config).call(@current_user, username)
            routing.halt 200, response_body.to_json
          rescue StandardError
            routing.halt 403, { message: 'Forbidden Request' }.to_json
          end
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
