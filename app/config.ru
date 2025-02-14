require 'roda'
require 'json'

require 'exceptions/invalid_direction_exception'
require 'exceptions/outofbound_exception'

require 'table'
require 'robot'
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

require './http/server'

run Http::Server