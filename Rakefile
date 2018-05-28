# frozen_string_literal: true

require 'rake/testtask'

task :load_all do
  require_relative 'init.rb'
end

task :load_libraries do
  require_relative 'lib/init.rb'
end

task :print_env do
  puts "Environment: #{ENV['RACK_ENV'] || 'development'}"
end

desc 'Run application console (pry)'
task :console => :print_env do
  sh 'pry -r ./specs/test_load_all'
end

desc 'Run application in development mode and port'
task :run_dev do
  puts "rackup at port #{ENV['RACK_PORT'] || '3000'}"
  sh "rerun -c 'rackup -p #{ENV['RACK_PORT'] || '3000'}'"
end

desc 'Rake all the Ruby'
task :rubocop do
  `rubopcop **/*.rb`
end

namespace :generate do
  desc 'Create rbnacl key'
  task :msg_key => :load_libraries do
    puts "New MSG_KEY (base64): #{SecureMessage.generate_key}"
  end

  desc 'Create cookie secret'
  task :session_secret => :load_libraries do
    puts "New SESSION_SECRET (base64): #{SecureSession.generate_secret}"
  end
end

namespace :session do
  desc 'Wipe all sessions stored in Redis'
  task :wipe => :load_all do
    #require 'redis'
    puts 'Deleting all sessions from Redis session store'
    wiped = SecureSession.wipe_redis_sessions
    puts "#{wiped.count} sessions deleted"
  end
end
