##
# Base class for each Entrypoints
#
class Entrypoint 
    ##
    #
    #
    def initialize
        @commands = Hash.new
    end

    ##
    #
    #
    def register_command command_name, config
        @commands[command_name] = config
    end

    ##
    #
    #
    def get_command command_name
        raise "Invalid command: #{command_name}" unless @commands.key?(command_name)

        @commands[command_name]
    end

    ##
    # Abstract method to implement actual call to the robot object
    #
    def process
        raise NotImplementedError, "Subclasses must implement the `process` method"
    end
end