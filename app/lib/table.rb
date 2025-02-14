##
# This class represents the robots plane
#
class Table 
    ##
    # Declares the the table `width` and `length`
    # Also declares the containers to hold all the `robots`
    #
    attr_accessor :width, :length, :robots

    ##
    # Constructor - will initialize default size of the plane, and the robots container
    # Width = 5
    # Length = 5
    # Robots = new array
    #
    def initialize width=5, length=5
        @width = width
        @length = length
        @robots = Array.new
    end

    ##
    # This method adds a robot into the table's robot container
    # only if the robot is not there yet
    #
    # @param [Robot] The robot object
    def add robot
        unless @robots.includes(robot)
            @robots << robot
        end
    end
end