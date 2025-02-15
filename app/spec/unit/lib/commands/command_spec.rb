require 'exceptions/invalid_direction_exception'
require 'exceptions/outofbound_exception'
require 'commands/command'

RSpec.describe Command do
    let(:command) { Command.new }

    describe "#execute" do 
        it "accepts two arguments" do 
            expect { command.execute("1") }.to raise_error(ArgumentError)
            expect { command.execute("1", "2", "3") }.to raise_error(ArgumentError)
            expect { command.execute("REPORT", []) }.to raise_error(NotImplementedError)
        end
    end
end