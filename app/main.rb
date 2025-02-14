##
# Usage: ruby main.rb [-r] [-d] < InputFile
# 
# Options:
#   -r    - Launches in REPL mode
#   -d    - Enable debug messages
#
# Example:
#   ruby main.rb -r
#   ruby main.rb -d < InputFile
#

require 'optparse'

require 'exceptions/invalid_direction_exception'
require 'exceptions/outofbound_exception'
require 'table'
require 'robot'

# Declare valid commands so the CLI does not happen to process invalid one
@valid_commands = ["PLACE", "LEFT", "RIGHT", "MOVE", "REPORT"]

##
# This method will accept the command, arguments and robot object
# and process it accoringly
#
# @params [String]   One of the \@valid_commands
# @params [String[]] Command's arguments
# @params [Robot]    The robot object being handled
#
def handle command, arguments = [], robot = nil
    # Ignore unknown commands
    unless @valid_commands.include?(command)
        debug("Command #{command} is not allowed")
    end
    
    case command
    when "PLACE"
        # destructure arguments object and assign to x, y and direction accordingly
        x, y, direction = arguments

        # execute the PLACE implementation
        robot.place(x.to_i, y.to_i, direction)
    when "LEFT"
        # make the robot 'turn left'
        robot.left()
    when "RIGHT"
        # make the robot 'turn right'
        robot.right()
    when "MOVE"
        # make the robot move forward 1 unit
        robot.move()
    when "REPORT"
        # returns the current position of the robot
        r = robot.report()

        # print out the position
        puts [r[:x], r[:y], r[:direction]].join(', ') unless r.nil?

        # return to caller
        return r
    end
end

##
# This method is a helper to parse input in the form of
# '<COMMAND> <COMMA-DELIMITED-ARGUMENTS>'
# and returns [<COMMAND>,[<ARG1>,<ARG2>,<ARG3>,....]]
#
# @params [String] input
def parse_command input
    command_parts = input.split " "

    # capture the first string as COMMAND, remove it from command_parts
    command = command_parts.shift

    # re-join the command_parts, then split by comma (,)
    # one will get [ARG1, ARG2, ARG3, ...]
    arguments = command_parts.join.split(",")

    # return as array for destructuring later
    [command, arguments]
end

##
# This is helper method for simplifying the debugging call
#
# @params [String] debug message
#
def debug message
    puts "[DEBUG] #{message}" if @options[:debug]
end

# BEGIN OPTION PARSER
@options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby main.rb [options]"

  opts.on("-r", "--repl", "Run in REPL mode") do |v|
    @options[:repl] = v
  end

  opts.on("-d", "--debug", "Show debug messages") do |v|
    @options[:debug] = v
  end
end.parse!
# END OPTION PARSER

# This will set-up SIGNAL handling
load 'lib/signal_handler.rb'

# Initialize the Table
@table = Table.new(5,5)

# Initialize the robot, and assign it above Table (for enumeration of max-width, max-length)
@robot1 = Robot.new(@table)

# handle REPL launch type
unless @options[:repl].nil?
    puts "Use CTRL+D or issue an 'exit' command to quit the REPL"

    loop do
        # REPL Prompt
        print "TABLE> "  

        # Read user input
        input = (input = gets).nil? ? "exit" : input.chomp  

        # Exit condition
        break if input.downcase == "exit"

        # skip whitespace and comments
        next if input.downcase.empty? || input.downcase.start_with?('#')

        begin
            # parse the input, then destructure input command, arguments array
            command, arguments = parse_command input

            # handle the command along with arguments, then capture the result
            result = handle(command, arguments, @robot1)

            # show debug message if debug mode enabled
            debug("Robot: " + @robot1.report.inspect)
        rescue Exception => e
            # show error message if debug mode enabled
            debug("Error: #{e.message}")
        end
    end

    # exit once done
    exit 0
end

# handle non-REPL launch type
loop do 
    begin
        # Read user input
        input = (input = gets).nil? ? "exit" : input.chomp  

        # Exit condition
        break if input.downcase == "exit"

        # skip whitespace and comments
        next if input.downcase.empty? || input.downcase.start_with?('#')
        
        # parse the input, then destructure input command, arguments array
        command, arguments = parse_command input

        # handle the command along with arguments, then capture the result
        result = handle(command, arguments, @robot1)

        # show debug message if debug mode enabled
        debug(@robot1.report.inspect)
    rescue Interrupt
        # handles CTRL+C
        break
    rescue Exception => e
        # show error message if debug mode enabled
        debug("Error: #{e.message}")
    end
end



