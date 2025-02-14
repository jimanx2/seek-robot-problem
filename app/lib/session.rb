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
end