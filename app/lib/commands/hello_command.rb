##
# Command class for the HELLO command
#
class HelloCommand < Command
    ##
    # @inherit
    #
    def execute robot, arguments
        "hello, #{arguments.first}"
    end
end