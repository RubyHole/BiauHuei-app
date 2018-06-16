# frozen_string_literal: true

# Returns an authenticated user, or nil
class AuthenticateGithubAccount
    def initialize(config)
      @config = config
    end
    
    def call(code)
      access_token = get_access_token_from_github(code)
      get_sso_account_from_api(access_token)
    end
    
    private
    
    def get_access_token_from_github(code)
      challenge_response =
        HTTP.headers(accept: 'application/json')
            .post(@config.GH_TOKEN_URL,
                  form: { client_id: @config.GH_CLIENT_ID,
                          client_secret: @config.GH_CLIENT_SECRET,
                          code: code })
      raise unless challenge_response.status < 400
      challenge_response.parse['access_token']
    end
    
    def get_sso_account_from_api(access_token)
      sso_info = { access_token: access_token }
      signed_sso_info = SecureMessage.sign(sso_info)
      
      response = HTTP.post("#{@config.API_URL}/auth/authenticate/github_sso",
                           json: signed_sso_info)
      response.code == 200 ? response.parse: nil
    end
end
