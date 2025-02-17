require 'exceptions'
require 'commands'
require 'entrypoints'
require 'session_driver'
require 'entrypoints'

require 'table'
require 'robot'

class CommandExecutorJob 
    @queue = :robot
    @entrypoint = CLIEntrypoint.new
    # register PLACE command, the value of x and y are in string, need to cast to integer
    @entrypoint.register_command "PLACE", executor: PlaceCommand.new

    # register LEFT command
    @entrypoint.register_command "LEFT", executor: LeftCommand.new

    # register RIGHT command
    @entrypoint.register_command "RIGHT", executor: RightCommand.new

    # register MOVE command
    @entrypoint.register_command "MOVE", executor: MoveCommand.new

    def self.with_session(session)
        @session = session
        self
    end

    def self.perform(session_id, command, arguments = [])
        @session ||= SessionDriver.new.from(session_id)
        @robot = @session.get('robot', Proc.new { nil })
        
        raise 'Corrupt session' if @robot.nil?
        
        executor = @entrypoint.get_command(command)
        executor[:executor].execute(@robot, arguments)
        
        @session.persist
    end
end