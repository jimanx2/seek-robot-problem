# This is Rackup configuration file for API Server
# - Pre-loads all the required classes and modules here

require 'resque'
require 'resque/server'

require './http/server'

Resque.redis = "#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}"
Resque.logger.level = Logger::DEBUG

# Runs the HTTP server
run Http::Server