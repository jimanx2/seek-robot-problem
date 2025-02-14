##
# Class to manage Session objects, also maintain
# the handle to the redis connection
#
class SessionDriver

    ##
    # Constructor - initialize Redis connection handle
    #
    def initialize
        @redis = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'])
    end

    ##
    # Create a new session object from given session_id
    # @param [String] current request's session_id
    def from session_id
        Session.new(@redis, session_id)
    end
end