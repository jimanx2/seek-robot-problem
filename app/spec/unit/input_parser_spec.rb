require 'input_parser'

RSpec.describe InputParser do

    include InputParser
    describe "#parse" do
        it "should be able to call parse()" do
            expect(self).to respond_to(:parse)
        end

        context "given one word input" do 
            it "should return [command, []]" do
                input = "oneword"
                result = parse input
                expect(result).to eq(["oneword", []])
            end
        end

        context "given two words input" do 
            it "should return [command, [args1]]" do
                input = "oneword secondword"
                result = parse input
                expect(result).to eq(["oneword", ["secondword"]])
            end
        end

        context "given two words input with second word delimited with comma (,)" do 
            it "should return [command, [args1,args2]]" do
                input = "oneword 1,2"
                result = parse input
                expect(result).to eq(["oneword", ["1","2"]])
            end
        end

        context "given two words input with second word delimited with comma (,) with variable spacing" do 
            it "should return [command, [args1,args2,args3,args4]]" do
                input = "oneword 1, 2,3 ,4"
                result = parse input
                expect(result).to eq(["oneword", ["1","2","3","4"]])
            end
        end
    end
end