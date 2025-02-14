##
# InputParser - A helper module for parsing robot command 
# from console or HTTP request
#
module InputParser

    ##
    # Method to parse console input
    # @params [String] The input line
    #
    def parse input_line
        # split the input line delimited by space
        command_parts = input_line.split " "

        # capture the first string as COMMAND, remove it from command_parts
        command = command_parts.shift

        # re-join the command_parts, then split by comma (,)
        # one will get [ARG1, ARG2, ARG3, ...]
        arguments = command_parts.join.split(",")

        # return as array for destructuring later
        [command, arguments]
    end

    ##
    # Method to parse Rack request
    # @params [Request] A Rack request
    #
    def parse_request request
        # get the command from request parameters, assigned in Server class
        command = request.params['command']

        # is this a JSON request?
        # if so, decode the JSON into arguments variable
        if !request.is_get? && request.headers['Content-Type'] == 'application/json'
            arguments = JSON.parse request.body.read
        end

        # returns commands and arguments, respectively.
        # replace arguments with empty array if not defined.
        [command, arguments || []]
    end
end