##
# Base class for each Entrypoints
#
class Entrypoint 
    ##
    # Abstract method to implement actual call to the robot object
    #
    def process
        raise NotImplementedError, "Subclasses must implement the `process` method"
    end
end