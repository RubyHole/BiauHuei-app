# frozen_string_literal: true

require 'roda'
require 'econfig'
require 'rack/ssl-enforcer'

module BiauHuei
  # Configuration for the API
  class App < Roda
    plugin :environments

    extend Econfig::Shortcut
    Econfig.env = environment.to_s
    Econfig.root = '.'

    configure :production do
      use Rack::SslEnforcer
    end

    configure :development, :test do
      # Allows running reload! in pry to restart entire app
      def self.reload!
        exec 'pry -r ./spec/test_load_all'
      end
    end
  end
end
