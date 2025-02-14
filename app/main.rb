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

require 'commands/command'
require 'commands/place_command'
require 'commands/left_command'
require 'commands/right_command'
require 'commands/move_command'
require 'commands/report_command'

require 'entrypoints/entrypoint'
require 'entrypoints/cli_entrypoint'

require 'table'
require 'robot'

require 'input_parser'
require 'debug'

include InputParser
include Debug

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

@entrypoint = CLIEntrypoint.new

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
            # handle the command along with arguments, then capture the result
            result = @entrypoint.process(input) do |executor, arguments|
                executor.execute(@robot1, arguments)
            end

            # show debug message if debug mode enabled
            debug("Robot: " + @robot1.report.inspect)
        rescue Exception => e
            # show error message if debug mode enabled
            debug("Error: #{e.to_s}")
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
        
        # handle the command along with arguments, then capture the result
        result = @entrypoint.process(input) do |executor, arguments|
            executor.execute(@robot1, arguments)
        end

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



