##
# Entrypoint class for CLI
#
class CLIEntrypoint < Entrypoint
    # we going to use parse_request, so we need this
    include InputParser

    ##
    # Method to extract the command and arguments from console input line
    # and returns the respective Command class
    # @params [Request] A rack request
    # @params [Proc] function to call
    #
    def process input_line
        # process the lines and return the command
        command_str, arguments = parse input_line
        
        # select the correct Command class
        # modify arguments as necessary
        case command_str
        when "PLACE"
            command = PlaceCommand.new
            arguments = [
                arguments[0].to_i,
                arguments[1].to_i,
                arguments[2]
            ]
        when "LEFT"
            command = LeftCommand.new
        when "RIGHT"
            command = RightCommand.new
        when "MOVE"
            command = MoveCommand.new
        when "REPORT"
            command = ReportCommand.new
            arguments = [:print]
        else
            raise "Invalid command: #{command_str}"
        end

        # execute the Proc passed by caller
        yield command, arguments
    end
end