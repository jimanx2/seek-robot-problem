require 'exceptions/invalid_argument_exception'
require 'exceptions/invalid_direction_exception'
require 'exceptions/outofbound_exception'
require 'commands/command'
require 'commands/place_command'
require 'robot'
require 'table'

RSpec.describe PlaceCommand, unit: true do
    let(:command) { PlaceCommand.new }
    let(:robot) { Robot.new(Table.new(5,5)) }

    describe "#initialize" do
        it "should inherit the command class" do 
            expect(command.class.ancestors.include?(Command)).to eq(true)
        end
    end 

    describe "#execute" do 
        it "Invokes robot.place()" do
            command.execute(robot, [1,2,'NORTH'])
            expect(robot.report).to eq({x: 1, y: 2, direction: 'NORTH'})
        end

        it "rejects invalid direction" do 
            expect { command.execute(robot, [0, 0, 'HEY']) }.to raise_error('This direction is not valid')
            expect { command.execute(robot, [1000,-24,'NORTH']) }.to raise_error('This placement is out of bound')
            expect { command.execute(robot, ['A','HEHEHEH','NORTH']) }.to raise_error('Argument passed is invalid')
        end
    end
end
