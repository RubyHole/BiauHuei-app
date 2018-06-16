# frozen_string_literal: true

# Returns an authenticated user, or nil
class AuthenticateGoogleAccount
    def initialize(config)
      @config = config
    end
    
    def call(code)
      access_token = get_access_token_from_google(code)
      get_sso_account_from_api(access_token)
    end
    
    private
    
    def get_access_token_from_google(code)
      challenge_response =
        HTTP.post(@config.GOOGLE_TOKEN_URL,
                  form: { code: code,
                          client_id: @config.GOOGLE_CLIENT_ID,
                          client_secret: @config.GOOGLE_CLIENT_SECRET,
                          redirect_uri: @config.GOOGLE_REDIRECT_URI,
                          grant_type: 'authorization_code' })
      raise unless challenge_response.status < 400
      challenge_response.parse['access_token']
    end
    
    def get_sso_account_from_api(access_token)
      sso_info = { access_token: access_token }
      signed_sso_info = SecureMessage.sign(sso_info)
      
      response = HTTP.post("#{@config.API_URL}/auth/authenticate/google_sso",
                           json: signed_sso_info)
      response.code == 200 ? response.parse: nil
    end
end
