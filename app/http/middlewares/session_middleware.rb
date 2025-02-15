##
# This is the session middleware which acts as facade
# for the actual SessionDriver class
#
class SessionMiddleware
    attr_reader :app, :session_driver
    
    ##
    # Constructor - Assigns the @app and @session object
    # @params [App] A rack app
    #
    def initialize(app)
        @app = app
        @session_driver = SessionDriver.new
    end

    ##
    # Middleware handler - Assigns @session to rack request env
    # @params [Env] Rack request env object
    #
    def call(env)
        env['session_driver'] = @session_driver

        # returns control to the next middleware
        @app.call(env)
    end
end