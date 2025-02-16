require 'yaml'
require 'psych'

##
# Class to load and store session data to Redis
#
class Session
    # declare the attributes
    attr_reader :id, :loaded_objects, :redis

    ##
    # Constructor - assigns local redis object and session_id, and initialize the loaded_objects
    # @params [Redis] A redis object
    # @params [String] Current request's session id
    #
    def initialize redis, session_id
        @id = session_id
        @redis = redis
        @loaded_objects = Hash.new
    end

    ##
    # Method to retrieve object from Redis, then cast to respective type
    # @params [String] the target key on redis
    # @params [Proc] fallback to call when not existing
    #
    def get(key, fallback)
        # key with session id
        idp_key = "{session:#{id}}::#{key}"
        # return early if redis does not have this key
        return @loaded_objects[idp_key] = fallback.call if !@redis.exists(idp_key)

        # return early if the retrieved value is empty
        value = @redis.get(idp_key)
        return @loaded_objects[idp_key] = fallback.call if value.nil? || value.empty?

        # check if value is valid YAML
        begin 
            Psych.parse(value)
        rescue Psych::SyntaxError => e
            warn "#{idp_key} does not contain a valid stored object representation (YAML)"
            warn "using fallback value"
            return @loaded_objects[idp_key] = fallback.call
        end

        # parse value into object and return it
        @loaded_objects[idp_key] = YAML.safe_load(value, permitted_classes: [Robot, Table], aliases: true)
    end

    ##
    # Method to update and store loaded_objects into Redis
    # - Uses the redis pipeline (aka Transaction pattern)
    # - Serializes each object using YAML
    def persist
        @redis.pipelined do |pipeline|
            @loaded_objects.each do |key, val|
                pipeline.set(key, val.to_yaml)
            end
        end
    end

    ##
    # Method to run the robot command in session lock to prevent
    # race condition if the command will take time to execute
    # A.K.A. real movement
    # @param [Proc] proc to call after acquiring session lock
    #
    def with_session_lock
        lock_key = "{task::#{id}}"

        # check if there is existing lock
        locked = @redis.exists(lock_key)

        # bailout if the session is locked
        raise SessionLockedException.new if locked == 1

        # no lock, attempt lock
        @redis.watch(lock_key)

        # use atomic operation
        success = @redis.multi do |tx|
            tx.set(lock_key, 1)
        end

        # success will = nil when the lock has been set by other
        # process
        raise LockReservedException.new unless success
        
        # execute the proc
        result = yield

        # remove redis watch
        @redis.unwatch

        # then delete the lock
        @redis.del(lock_key)

        # return result
        result
    end
end
