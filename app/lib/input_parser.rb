require 'json'

module InputParser

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

    def parse_request request
        command = request.params['command']

        if !request.is_get? && request.headers['Content-Type'] == 'application/json'
            arguments = JSON.parse request.body.read
        end

        [command, arguments || []]
    end
end