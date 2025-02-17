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

# Pre loads all the required classes and modules
require 'optparse'

require 'table'
require 'robot'

require 'debug'

include Debug

require 'exceptions'
require 'commands'
require 'entrypoints'

# BEGIN OPTION PARSER
# Parse command line options
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

# Create CLI Entrypoint for command handling
@entrypoint = CLIEntrypoint.new

# register PLACE command, the value of x and y are in string, need to cast to integer
@entrypoint.register_command "PLACE", executor: PlaceCommand.new, arg_modifier: (Proc.new do |arguments|
    x, y, direction = arguments
    [x.to_i, y.to_i, direction]
end)

# register LEFT command
@entrypoint.register_command "LEFT", executor: LeftCommand.new

# register RIGHT command
@entrypoint.register_command "RIGHT", executor: RightCommand.new

# register MOVE command
@entrypoint.register_command "MOVE", executor: MoveCommand.new

# register REPORT command, we add :print here because
# we wanted the robot to display the position and direction
@entrypoint.register_command "REPORT", executor: ReportCommand.new, arg_modifier: (Proc.new do |arguments|
    [:print]
end)

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
            result = @entrypoint.process(input) do |executor, command, arguments|
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

# handle non-REPL launch type (eg: File processing)
loop do 
    begin
        # Read user input
        input = (input = gets).nil? ? "exit" : input.chomp  

        # Exit condition
        break if input.downcase == "exit"

        # skip whitespace and comments
        next if input.downcase.empty? || input.downcase.start_with?('#')
        
        # handle the command along with arguments, then capture the result
        result = @entrypoint.process(input) do |executor, command, arguments|
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



