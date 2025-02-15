require 'exceptions/invalid_direction_exception'
require 'exceptions/outofbound_exception'
require 'commands/command'
require 'commands/move_command'
require 'robot'
require 'table'

RSpec.describe MoveCommand do
    let(:command) { MoveCommand.new }
    let(:robot) { Robot.new(Table.new(5,5)) }

    describe "#initialize" do
        it "should inherit the command class" do 
            expect(command.class.ancestors.include?(Command)).to eq(true)
        end
    end 

    describe "#execute" do 
        it "Invokes robot.move()" do
            expect(command.execute(robot, [])).to eq(nil)
            robot.place(1,1,'NORTH')
            command.execute(robot, [])
            expect(robot.report).to eq({x:1, y:2, direction: 'NORTH'})
            robot.left()
            command.execute(robot, [])
            expect(robot.report).to eq({x:0, y:2, direction: 'WEST'})
        end

        it "rejects invalid position" do
            robot.place(0,0,'WEST')
            expect { command.execute(robot, []) }.to raise_error('This movement will cause the robot to fall out.')

            robot.place(4,4,'EAST')
            expect { command.execute(robot, []) }.to raise_error('This movement will cause the robot to fall out.')

            robot.place(0,4,'NORTH')
            expect { command.execute(robot, []) }.to raise_error('This movement will cause the robot to fall out.')

            robot.place(4,0,'SOUTH')
            expect { command.execute(robot, []) }.to raise_error('This movement will cause the robot to fall out.')
        end
    end
end
