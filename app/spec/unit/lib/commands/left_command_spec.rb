require 'exceptions/invalid_direction_exception'
require 'exceptions/outofbound_exception'
require 'commands/command'
require 'commands/left_command'
require 'robot'
require 'table'

RSpec.describe LeftCommand do
    let(:command) { LeftCommand.new }
    let(:robot) { Robot.new(Table.new(5,5)) }

    describe "#initialize" do
        it "should inherit the command class" do 
            expect(command.class.ancestors.include?(Command)).to eq(true)
        end
    end 

    describe "#execute" do 
        it "Invokes robot.left()" do
            expect(command.execute(robot, [])).to eq(nil)
            robot.place(1,1,'NORTH')
            command.execute(robot, [])
            expect(robot.report).to eq({x:1, y:1, direction: 'WEST'})
        end
    end
end
