require 'exceptions/invalid_direction_exception'
require 'exceptions/outofbound_exception'
require 'table'
require 'robot'

RSpec.describe Robot do 
	let(:table) { Table.new(5,5) }
	let(:robot) { Robot.new(table) }
  
	describe "#initialize" do
		it "initializes with no position and direction" do
			expect(robot.x).to be_nil
			expect(robot.y).to be_nil
			expect(robot.direction).to be_nil
		end
	end

	describe "#place" do
		context "when given valid parameters" do
			it "sets the position and direction correctly" do
				robot.place(1, 2, "NORTH")
				expect(robot.x).to eq(1)
				expect(robot.y).to eq(2)
				expect(robot.direction).to eq(0)  # "NORTH" is at index 0
			end
		end

		context "when given invalid x-coordinate" do
			it "raises an OutofboundException" do
				expect { robot.place(5, 2, "NORTH") }.to raise_error("This placement is out of bound")
			end
		end

		context "when given invalid y-coordinate" do
			it "raises an OutofboundException" do
				expect { robot.place(1, 5, "NORTH") }.to raise_error("This placement is out of bound")
			end
		end

		context "when given invalid direction" do
			it "raises an InvalidDirectionException" do
				expect { robot.place(1, 2, "INVALID_DIRECTION") }.to raise_error("This direction is not valid")
			end
		end
	end

	describe "#left" do
		it "turns the robot 90 degrees counter-clockwise" do
			robot.place(1, 1, "NORTH")
			robot.left
			expect(robot.direction).to eq(3)  # "WEST"
		end

		it "wraps around when turning left from NORTH" do
			robot.place(1, 1, "NORTH")
			robot.left
			robot.left
			robot.left
			robot.left
			expect(robot.direction).to eq(0)  # "NORTH"
		end
	end

	describe "#right" do
		it "turns the robot 90 degrees clockwise" do
			robot.place(1, 1, "NORTH")
			robot.right
			expect(robot.direction).to eq(1)  # "EAST"
		end

		it "wraps around when turning right from WEST" do
			robot.place(1, 1, "WEST")
			robot.right
			robot.right
			robot.right
			robot.right
			expect(robot.direction).to eq(3)  # "WEST"
		end
	end

	describe "#move" do
		context "when position is set" do
			it "moves the robot one unit forward" do
				robot.place(1, 1, "NORTH")
				robot.move
				expect(robot.x).to eq(1)
				expect(robot.y).to eq(2)
			end

			it "raises an OutofboundException when trying to move out of bounds" do
				robot.place(0, 0, "WEST")
				expect { robot.move }.to raise_error("This movement will cause the robot to fall out.")
			end
		end

		context "when position is not set" do
			it "does not move the robot" do
				robot.move
				expect(robot.x).to be_nil
				expect(robot.y).to be_nil
			end
		end
	end

	describe "#report" do
		context "when position is set" do
			it "returns the correct position and direction" do
				robot.place(2, 3, "EAST")
				report = robot.report
				expect(report).to eq({ x: 2, y: 3, direction: "EAST" })
			end
		end

		context "when position is not set" do
			it "returns nil" do
				expect(robot.report).to be_nil
			end
		end
	end
end