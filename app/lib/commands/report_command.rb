class ReportCommand < Command
    def execute robot, arguments
        if arguments[:print] == true
            result = robot.report()
            puts "#{result[:x]}, #{result[:y]}, #{result[:direction]}" unless result.nil?
            return
        end

        robot.report()
    end
end