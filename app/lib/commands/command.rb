class Command 
    def execute robot
        raise NotImplementedError, "Subclasses must implement the `execute` method"
    end
end