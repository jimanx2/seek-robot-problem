require 'debug'

RSpec.describe Debug, unit: true do

    include Debug
    describe "#debug" do
        it "should be able to call debug()" do
            expect(self).to respond_to(:debug)
        end

        it "should print debug message when command line options :debug is true" do
            @options = { debug: true }
            expect(STDOUT).to receive(:puts).with('[DEBUG] debug message')
            debug("debug message")
        end

        it "should not print debug message when command line options :debug is not set or false" do 
            @options = {}
            expect(STDOUT).to_not receive(:puts).with('[DEBUG] debug message')
            debug("debug message")

            @options = { debug: false }
            expect(STDOUT).to_not receive(:puts).with('[DEBUG] debug message')
            debug("debug message")
        end
    end
end