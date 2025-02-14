# Adds inherit_from matcher for RSpec
module InheritFromMatcher
    RSpec::Matchers.define :inherit_from do |superclass|
        match do |klass|
        klass.class.ancestors.include? superclass
        end
    
        failure_message_for_should do |klass|
        "expected #{klass.class.name} to inherit from #{superclass}"
        end
    
        failure_message_for_should_not do |klass|
        "expected #{klass.class.name} not to inherit from #{superclass}"
        end
    end
end