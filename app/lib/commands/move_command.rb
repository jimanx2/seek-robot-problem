##
# Command class for the MOVE command
#
class MoveCommand < Command
    ##
    # @inherit
    #
    def execute robot, arguments
        sleep rand(3)
        robot.move()
    end
end