class SessionDriver

    def initialize
        @redis = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'])
    end

    def from session_id
        Session.new(session_id)
    end
end