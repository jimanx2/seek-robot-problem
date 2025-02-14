class Entrypoint 
    def process
        raise NotImplementedError, "Subclasses must implement the `process` method"
    end
end