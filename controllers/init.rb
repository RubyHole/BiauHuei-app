# frozen_string_literal: true

require_relative 'app.rb'

Dir.glob("#{File.dirname(__FILE__)}/**/*.rb").each do |file|
  require file
end
