##
# Base class for each Entrypoints
#
class Entrypoint 
    ##
    # Constructor - initializes the command registry
    #
    def initialize
        @registry = Hash.new
    end

    ##
    # adds new command into command registry,
    # checks if a command config is not valid
    # @params [String] name of command
    # @params [Hash]   command config
    #
    def register_command command_name, config
        raise "Invalid config" if !config.key?(:executor)
        raise "Invalid config" if config.key?(:arg_modifier) && !config[:arg_modifier].is_a?(Proc)
        @registry[command_name] = config
    end

    ##
    # checks if a command exist, and return the config
    # @params [String] name of command
    #
    def get_command command_name
        raise "Invalid command: #{command_name}" unless @registry.key?(command_name)

        @registry[command_name]
    end

    ##
    # Abstract method to implement actual call to the robot object
    #
    def process
        raise NotImplementedError, "Subclasses must implement the `process` method"
    end
end