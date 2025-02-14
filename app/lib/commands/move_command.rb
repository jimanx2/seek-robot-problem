class MoveCommand < Command
    def execute robot, arguments
        robot.move()
    end
end