# frozen_string_literal: true

module BiauHuei
  # Managing session information
  class Session
    def initialize(secure_session)
      @secure_session = secure_session
    end

    def get_user
      User.new(@secure_session.get(:account),
               @secure_session.get(:auth_token))
    end

    def set_user(user)
      @secure_session.set(:account, user.account)
      @secure_session.set(:auth_token, user.auth_token)
    end

    def delete
      @secure_session.delete(:account)
      @secure_session.delete(:auth_token)
    end
  end
end
