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
        command_str, arguments = parse_request(request)
        
        # identify command
        command = get_command(command_str)

        # see if the arguments needs to be modified
        if command.key?(:arg_modifier) && command[:arg_modifier].is_a?(Proc)
            arguments = command[:arg_modifier].call(arguments) 
        end

        # execute the Proc passed by caller
        yield command[:executor], arguments
    end
end