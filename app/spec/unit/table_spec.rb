require 'exceptions/invalid_direction_exception'
require 'exceptions/outofbound_exception'
require 'table'

RSpec.describe Table do
    let(:table) { Table.new }  # A default 5x5 table
    let(:robot) { double("Robot") }  # Mocking the robot object

    describe "#initialize" do
        it "sets default width to 5" do
        expect(table.width).to eq(5)
        end

        it "sets default length to 5" do
        expect(table.length).to eq(5)
        end

        it "initializes an empty robots array" do
        expect(table.robots).to be_empty
        end
    end

    describe "#add" do
        context "when adding a robot" do
            it "adds the robot to the table's robots array" do
                table.add(robot)
                expect(table.robots).to include(robot)
            end

            it "does not add the same robot twice" do
                table.add(robot)
                table.add(robot)  # Adding the same robot again
                expect(table.robots.size).to eq(1)  # Robot should appear only once
            end
        end
    end
end
