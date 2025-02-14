class PlaceCommand < Command
    def execute robot, arguments
        x, y, direction = arguments

        robot.place(x, y, direction)
    end
end