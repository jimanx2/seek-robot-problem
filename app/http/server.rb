require 'roda'
require 'json'
require 'securerandom'

require 'input_parser'
require 'debug'
require 'exceptions'
require 'commands'
require 'entrypoints'
require 'session_driver'
require 'entrypoints'

require './http/jobs/command_executor_job'
require './http/middlewares/session_middleware'

require 'table'
require 'robot'

##
# Http - Module for the API entrypoint
#
module Http
    ##
    # This class represent the API server object for the Robot API
    #
    class Server < Roda
        # load plugin to access the request header
        plugin :request_headers

        # load plugin to respond with JSON format
        plugin :json

        # load plugin to enable request event hook
        plugin :hooks 

        # load and use the SessionMiddleware handler
        # - this is used to store/load session data
        #   from Redis
        use SessionMiddleware

        ##
        # constructor
        # @params [Array] default arguments for Roda class
        #
        def initialize args
            # need to call this because parent class requires arguments
            super args

            # initialize the ApiEntrypoint class
            @api = ApiEntrypoint.new

            # register PLACE command, since arguments in Hash format, we need to change it to 
            # array format [x,y,direction]
            @api.register_command "PLACE", executor: PlaceCommand.new, arg_modifier: (Proc.new do |arguments|
                [arguments["x"].to_i, arguments["y"].to_i, arguments["direction"]]
            end)

            # register LEFT command
            @api.register_command "LEFT", executor: LeftCommand.new

            # register RIGHT command
            @api.register_command "RIGHT", executor: RightCommand.new

            # register MOVE command
            @api.register_command "MOVE", executor: MoveCommand.new

            # register REPORT command
            @api.register_command "REPORT", executor: ReportCommand.new
        end

        ##
        # Re-usable method to handle the request
        # @params [Request] Rack request object
        #
        def handle_robot_request r
            # retrieve the robot object from request env
            @robot = r.env['robot']

            # retrieve the session object
            @session = r.env['session']

            # trigger the ApiEntrypoint process, and get the result
            # - the method will yield a function with two arguments:
            #   executor and arguments, executor is one of the Command
            #   classes
            # - with executor, we can call the actual process on the
            #   robot object via the .execute method
            # - the executor has a method `should_lock?` to determine
            #   whether a command should be run without race condition
            #   use the @session.with_session_lock to exercise this
            res = @api.process(r) do |executor, command, arguments|
                # exception handled
                begin 
                    if executor.should_lock?
                        return @session.with_session_lock do 
                            executor.execute(@robot, arguments)
                        end
                    end
                    executor.execute(@robot, arguments)
                rescue SessionLockedException
                    # Queue the command
                    Resque.enqueue(CommandExecutorJob, @session.id, command, arguments)
                    raise "Robot busy. Command has been queued."
                rescue LockReservedException
                    raise "Robot cannot be reserved."
                end
            end
            return res
        end

        # before route hook
        # load the session objects via header X-Session-Id
        # if none, initialize a new X-Session-Id with a generated UUID.
        # meanwhile, create a session instance to load objects from
        # redis. then, assign respective objects to request env
        before do 
            request.env['session_id'] = request.headers['X-Session-Id'] || SecureRandom.uuid
            session = request.env['session_driver'].from(request.env['session_id'])
            request.env['session'] = session
            request.env['table'] = session.get('table', Proc.new { Table.new(5,5) })
            request.env['robot'] = session.get('robot', Proc.new { Robot.new(request.env['table']) })
        end

        # after route hook
        # this will attempt to store and update the session objects value 
        # back to redis using YAML serialization
        # also, the X-Session-ID will be spit out to the API response
        # header
        after do 
            request.env['session'].persist
            response['X-Sessiond-Id'] = request.env['session_id']
        end

        # route definitions
        route do |r|
            # GET /api/robot/report
            r.get 'api/robot/report' do
                r.params['command'] = 'REPORT'
                res = handle_robot_request(r)

                { :status => 'success', :message => res || "Command completed successfully" }
            rescue Exception => ex
                response.status = 400
                next { :status => 'error', :message => ex.message }
            end
            
            # POST /api/robot/:command
            r.post 'api/robot', String do |command|
                r.params['command'] = command.upcase
                res = handle_robot_request(r)

                { :status => 'success', :message => res || "Command completed successfully" }
            rescue Exception => ex
                response.status = 400
                next { :status => 'error', :message => ex.message }
            end 
        end
    end
end
