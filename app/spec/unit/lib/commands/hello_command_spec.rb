# these are examples of requiring dependencies to run this test
# modify as you see fit
#
require 'commands/command'
require 'commands/hello_command'

RSpec.describe HelloCommand, unit: true do
    let(:command) { HelloCommand.new }

    describe "#initialize" do 
        it "should inherit the command class" do 
            expect(command.class.ancestors.include?(Command)).to eq(true)
        end
    end 
end