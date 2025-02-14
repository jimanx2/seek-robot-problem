# This is Rackup configuration file for API Server
# - Pre-loads all the required classes and modules here

require 'roda'
require 'json'
require 'redis'
require 'securerandom'
require 'yaml'

require 'exceptions/invalid_direction_exception'
require 'exceptions/outofbound_exception'

require 'table'
require 'robot'
require 'session'
require 'session_driver'
require 'input_parser'
require 'debug'

require 'commands/command'
require 'commands/place_command'
require 'commands/left_command'
require 'commands/right_command'
require 'commands/move_command'
require 'commands/report_command'

require 'entrypoints/entrypoint'
require 'entrypoints/api_entrypoint'

require './http/middlewares/session_middleware'
require './http/server'

# Runs the HTTP server
run Http::Server