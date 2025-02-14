##
# This class represents a robot object
#
class Robot
    ##
    # Declares the x, and y position
    # Also declares the direction robot is facing
    #
    attr_reader :x, :y, :direction
    attr_reader :directions

    ##
    # Constructor - initializes a robot object with initial value
    #
    # @params [Table] The table object's reference
    #
    def initialize table
        @table = table
        @x = nil
        @y = nil
        @direction = nil
        @directions = ["NORTH", "EAST", "SOUTH", "WEST"]
    end

    ##
    # This method will set the robot position and face direction
    #
    # @params [Integer] Horizontal position
    # @params [Integer] Vertical position
    # @params [String]  Face direction, only accepts NORTH|WEST|SOUTH|EAST 
    def place x, y, direction
        # checks if x is is valid range [0,table.length - 1]
        if 0 > x || x > @table.width - 1
            raise OutofboundException.new
        end

        # checks if y is in valid range [0,table.length - 1]
        if 0 > y || y > @table.length - 1
            raise OutofboundException.new
        end

        # checks if direction is not one of NORTH|WEST|SOUTH|EAST
        unless @directions.include?(direction)
            raise InvalidDirectionException.new
        end

        # sets the position and face direction accordingly
        @x = x
        @y = y
        @direction = @directions.index(direction)

        return
    rescue OutofboundException
        raise "This placement is out of bound"
    rescue InvalidDirectionException
        raise "This direction is not valid"
    end

    ##
    # This method will turn the robot facing 90deg counter-clockwise
    #
    def left
        # rotate the direction index to the end if it reach the first 
        if @direction - 1 < 0
            @direction = 3
            return
        end

        # otherwise return the direction of previous index
        @direction -= 1

        return
    end

    ##
    # This method will turn the robot facing 90deg clockwise
    #
    def right
        # rotate the direction index to the start if it exceeds the last
        if @direction + 1 > @directions.count - 1
            @direction = 0 
            return nil 
        end

        # otherwise return the direction of next index
        @direction += 1
        
        return
    end

    ##
    # This method will move the robot 1 unit forward
    #
    def move
        # ignore move commands when position not initialized
        return if @x.nil? || @y.nil? || @direction.nil?

        # 'simulate' resulting x and y position
        target_x, target_y = case @directions[@direction]
            when "NORTH"
                [@x, @y + 1]
            when "SOUTH"
                [@x, @y - 1]
            when "WEST"
                [@x - 1, @y]
            when "EAST"
                [@x + 1, @y]
        end

        # based on simulation result determine if it's out of bound,
        # if so, reject the command
        raise OutofboundException.new if target_x < 0 || target_x > @table.length - 1
        raise OutofboundException.new if target_y < 0 || target_y > @table.width - 1

        # otherwise, update the current position with simulation position
        @x, @y = [target_x, target_y]

        return
    rescue OutofboundException
        raise "This movement will cause the robot to fall out."
    end

    ##
    # This method will return the robot's current position and face direction
    #
    def report
        # ignore move commands when position not initialized
        return if @x.nil? || @y.nil? || @direction.nil?
        
        # returns the position and face direction in form of
        # symbol(x, y, direction)
        return { x: @x, y: @y, direction: @directions[@direction].nil? ? nil : @directions[@direction] }
    end
end