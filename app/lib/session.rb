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
        # return early if redis does not have this key
        return @loaded_objects[key] = fallback.call if !@redis.exists(key)

        # return early if the retrieved value is empty
        value = @redis.get(key)
        return @loaded_objects[key] = fallback.call if value.empty?

        # check if value is valid YAML
        begin 
            YAML.parse!(value)
        rescue
            warn "#{key} does not contain a valid stored object representation (YAML)"
            warn "using fallback value"
            return @loaded_objects[key] = fallback.call
        end

        # parse value into object and return it
        @loaded_objects[key] = YAML.safe_load(value, permitted_classes: [Robot, Table], aliases: true)
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
    #
    #
    def with_session_lock
        task_key = "{task::#{id}}"

        task = @redis.hgetall(task_key)
        if task.nil?
            raise TaskNotExistException.new
        elsif task["status"] == "pending"
            expect_version = task["lock_version"]
            
            result = yield
            current_version = @redis.hget(task_key, "status", "completed")
            if current_version == expect_version
                @redis.multi do
                    @redis.hset(task_key, "status", "completed")
                    @redis.hincrby(task_key, "lock_version", 1)
                end

                result
            else
                raise TaskSuperseededException.new
            end
        else
            raise TaskAlreadyDoneException.new
        end
    end
end
