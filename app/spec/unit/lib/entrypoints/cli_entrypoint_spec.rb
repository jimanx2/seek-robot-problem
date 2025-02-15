require 'json'
require 'input_parser'
require 'robot'
require 'table'

require 'entrypoints/entrypoint'
require 'entrypoints/cli_entrypoint'
require 'commands/command'
require 'commands/hello_command'

RSpec.describe CLIEntrypoint do
    let(:entrypoint) { CLIEntrypoint.new }

    # Mock the input line
    let(:input) { "HELLO world" } 

    describe "#initialize" do 
        it "should inherit the Entrypoint class" do 
            expect(entrypoint.class.ancestors.include?(Entrypoint)).to eq(true)
            expect(entrypoint).to respond_to(:register_command)
            expect(entrypoint).to respond_to(:get_command)
            expect(entrypoint).to respond_to(:process)
            expect(entrypoint).to respond_to(:parse_request)
        end
    end

    describe "#process" do 
        it "handles a valid request (HELLO)" do 
            entrypoint.register_command "HELLO", executor: HelloCommand.new, arg_modifier: (Proc.new do |arguments|
                [arguments[0]]
            end)
            result = entrypoint.process(input) do |executor, arguments|
                executor.execute(Robot.new(Table.new(5,5)), arguments)
            end
            expect(result).to eq("hello, world")
        end

        it "rejects an invalid request (HOLA)" do 
            expect { entrypoint.process("HOLA bro!") }.to raise_error("Invalid command: HOLA")
        end
    end
end