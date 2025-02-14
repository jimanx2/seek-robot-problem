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
        # it "inherits the Command class" do 
        #     expect(LeftCommand).to inherit_from(Command)
        # end
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
