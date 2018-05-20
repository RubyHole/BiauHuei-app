# frozen_string_literal: true

require 'roda'
require 'econfig'
require 'rack/ssl-enforcer'
require 'rack/session/redis'

module BiauHuei
  # Configuration for the API
  class App < Roda
    plugin :environments

    extend Econfig::Shortcut
    Econfig.env = environment.to_s
    Econfig.root = '.'
    
    configure do
      SecureSession.setup(config)
      SecureMessage.setup(config)
    end
    
    ONE_MONTH = 30 * 24 * 60 * 60 # in seconds

    configure :development, :test do
      # use Rack::Session::Cookie,
      #     expire_after: ONE_MONTH, secret: config.SESSION_SECRET

      # use Rack::Session::Pool,
      #     expire_after: ONE_MONTH

      use Rack::Session::Redis,
          expire_after: ONE_MONTH, redis_server: App.config.REDIS_URL
    end

    configure :production do
      use Rack::SslEnforcer, :hsts => true

      use Rack::Session::Redis,
          expire_after: ONE_MONTH, redis_server: App.config.REDIS_URL
    end

    configure :development, :test do
      # Allows running reload! in pry to restart entire app
      def self.reload!
        exec 'pry -r ./specs/test_load_all'
      end
    end
  end
end
