##
# Command class for the MOVE command
#
class MoveCommand < Command
    ##
    # @inherit
    #
    def execute robot, arguments
        delay = arguments.first
        sleep(delay) unless delay.nil?
        robot.move()
    end
end