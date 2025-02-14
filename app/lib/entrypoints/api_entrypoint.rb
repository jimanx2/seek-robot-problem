class ApiEntrypoint < Entrypoint
    include InputParser
    
    VALID_COMMANDS = ["PLACE", "LEFT", "RIGHT", "MOVE", "REPORT"]

    def process request
        # process the lines and return the command
        command_str, arguments = parse_request request
        
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
            raise "Invalid command: #{command_str}"
        end

        yield command, arguments
    end
end