# frozen_string_literal: true

require 'roda'
require 'slim'

module BiauHuei
  # Base class for Credence Web Application
  class App < Roda
    plugin :render, engine: 'slim', views: 'views'
    plugin :assets, css: 'style.css', path: 'assets'
    plugin :public, root: 'public'
    plugin :multi_route
    plugin :flash

    ONE_MONTH = 30*24*60*60

    use Rack::Session::Cookie,
        expire_after: ONE_MONTH,
        secret: config.SESSION_SECRET

    route do |routing|
      @current_account = session[:current_account]

      routing.public
      routing.assets
      routing.multi_route

      # GET /
      routing.root do
        view 'home', locals: { current_account: @current_account }
      end
    end
  end
end
