class LeftCommand < Command
    def execute robot, arguments
        robot.left()
    end
end