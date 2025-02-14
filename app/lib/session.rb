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
            _klass = value['class']
            _data  = value['data']
            value = _klass.new(_data)
        else
            value = fallback
        end
        @loaded_objects[key] = value
    end

    def persist

    end

    private
    def _real_get 
end