# frozen_string_literal: true

module BiauHuei
  # Behaviors of the currently logged in account
  class User
    def initialize(account, auth_token)
      @account = account
      @auth_token = auth_token
    end

    attr_reader :account, :auth_token

    def username
      @account ? @account['username'] : nil
    end

    def email
      @account ? @account['email'] : nil
    end

    def logged_out?
      @account.nil?
    end

    def logged_in?
      not logged_out?
    end
  end
end
