require 'exceptions/invalid_direction_exception'
require 'exceptions/outofbound_exception'
require 'commands/command'
require 'commands/report_command'
require 'robot'
require 'table'

RSpec.describe ReportCommand do
    let(:command) { ReportCommand.new }
    let(:robot) { Robot.new(Table.new(5,5)) }

    describe "#initialize" do
        # it "inherits the Command class" do 
        #     expect(ReportCommand).to inherit_from(Command)
        # end
    end 

    describe "#execute" do 
        it "Invokes robot.report()" do
            expect(command.execute(robot, [])).to eq(nil)

            robot.place(1,1,'NORTH')
            expect(robot.report).to eq({x:1, y:1, direction:'NORTH'})
        end
    end
end
