require 'input_parser'

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
        
        # identify command
        command = get_command(command_str)

        # see if the arguments needs to be modified
        if command.key?(:arg_modifier) && command[:arg_modifier].is_a?(Proc)
            arguments = command[:arg_modifier].call(arguments) 
        end

        # execute the Proc passed by caller
        yield command[:executor], command_str, arguments
    end
end