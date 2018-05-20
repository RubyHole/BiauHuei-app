# frozen_string_literal: true

# run pry -r <path/to/this/file> or make rake task to do so

require_relative '../init'

require 'rack/test'
include Rack::Test::Methods

def app
  BiauHuei::App
end
