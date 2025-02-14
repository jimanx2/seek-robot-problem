##
# Command class for the LEFT command
#
class PlaceCommand < Command
    ##
    # @inherit
    #
    def execute robot, arguments
        x, y, direction = arguments

        robot.place(x, y, direction)
    end
end