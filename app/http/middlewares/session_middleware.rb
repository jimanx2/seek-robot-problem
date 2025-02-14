class SessionMiddleware
    def initialize(app)
        @app = app
        @session = SessionDriver.new
    end

    def call(env)
        env['session'] = @session

        @app.call(env)
    end
end