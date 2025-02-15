require 'input_parser'
require 'entrypoints/entrypoint'
require 'entrypoints/api_entrypoint'

RSpec.describe ApiEntrypoint do
    let(:entrypoint) { ApiEntrypoint.new }

    describe "#initialize" do 
        it "should inherit the Entrypoint class" do 
            expect(entrypoint.class.ancestors.include?(Entrypoint)).to eq(true)
            expect(entrypoint).to respond_to(:register_command)
            expect(entrypoint).to respond_to(:get_command)
            expect(entrypoint).to respond_to(:process)
        end
    end
end