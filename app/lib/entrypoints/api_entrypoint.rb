##
# Entrypoint class for API server
#
class ApiEntrypoint < Entrypoint
    # we going to use parse_request, so we need this
    include InputParser

    ##
    # Method to extract the command and arguments from HTTP request
    # and returns the respective Command class
    # @params [Request] A rack request
    # @params [Proc] function to call
    #
    def process request
        # process the request and return the command, arguments
        command_str, arguments = parse_request request
        
        # select the correct Command class
        # modify arguments as necessary
        case command_str
        when "PLACE"
            command = PlaceCommand.new
            arguments = [
                arguments["x"].to_i, 
                arguments["y"].to_i, 
                arguments["direction"]
            ]
        when "LEFT"
            command = LeftCommand.new
        when "RIGHT"
            command = RightCommand.new
        when "MOVE"
            command = MoveCommand.new
        when "REPORT"
            command = ReportCommand.new
        else
            # raise an error if the command is unrecognized
            raise "Invalid command: #{command_str}"
        end

        # execute the Proc passed by caller
        yield command, arguments
    end
end