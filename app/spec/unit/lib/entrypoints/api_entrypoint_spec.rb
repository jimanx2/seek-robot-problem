require 'json'
require 'input_parser'
require 'robot'
require 'table'

require 'entrypoints/entrypoint'
require 'entrypoints/api_entrypoint'
require 'commands/command'
require 'commands/hello_command'

RSpec.describe ApiEntrypoint do
    let(:entrypoint) { ApiEntrypoint.new }

    # Mock the Rake request 
    let(:request) do
        Class.new {
            def initialize
                @params = { 'command' => 'HELLO' }
            end
            def set_param key, val
                @params[key] = val
            end
            def params
                @params
            end
            def is_get? 
                false
            end
            def headers 
                { 'Content-Type' => 'application/json' }
            end
            def body 
                Struct.new {
                    def read 
                        '{"hello":"world"}'
                    end
                }.new
            end
        }.new
    end

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
                [arguments["hello"]]
            end)
            result = entrypoint.process(request) do |executor, arguments|
                executor.execute(Robot.new(Table.new(5,5)), arguments)
            end
            expect(result).to eq("hello, world")
        end

        it "rejects an invalid request (HOLA)" do 
            request.set_param 'command', 'HOLA'
            expect { entrypoint.process(request) }.to raise_error("Invalid command: HOLA")
        end
    end
end