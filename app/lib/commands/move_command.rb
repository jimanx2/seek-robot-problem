##
# Command class for the MOVE command
#
class MoveCommand < Command
    ##
    # @inherit
    #
    def execute robot, arguments
        robot.move()
    end
end