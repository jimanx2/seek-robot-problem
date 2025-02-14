##
# Command class for the RIGHT command
#
class RightCommand < Command
    ##
    # @inherit
    #
    def execute robot, arguments
        robot.right()
    end
end