class Session
    attr_reader :id, :loaded_objects, :redis
    def initialize redis, session_id
        @id = session_id
        @redis = session_id
        @loaded_objects = Hash.new
    end

    def get(key, fallback)
        value = @redis.get(key)
        unless value.nil?
            klass = Object.const_get(value['class'])
            data  = value['data']
            value = klass.from_json(data)
        else
            value = fallback
        end
        @loaded_objects[key] = value
    end

    def persist

    end
end