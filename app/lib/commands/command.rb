##
# Base class for each Robot Command
#
class Command 
    ##
    # Abstract method to implement actual call to the robot object
    # @params [Robot] the Robot object
    # @params [Array] arguments from entrypoint
    #
    def execute robot, arguments
        raise NotImplementedError, "Subclasses must implement the `execute` method"
    end

    ##
    # Abstract method to determine whether a command should use session lock
    # Defaults to true
    #
    def should_lock?
        true
    end
end