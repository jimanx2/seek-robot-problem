##
# Command class for the LEFT command
#
class LeftCommand < Command
    ##
    # @inherit
    #
    def execute robot, arguments
        robot.left()
    end
end