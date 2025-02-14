class CLIEntrypoint < Entrypoint
    VALID_COMMANDS = ["PLACE", "LEFT", "RIGHT", "MOVE", "REPORT"]
    def process input_line
        # process the lines and return the command
        command_str, arguments = parse input_line
        
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

        yield command, arguments
    end
end