module Debug
    ##
    # This is helper method for simplifying the debugging call
    #
    # @params [String] debug message
    #
    def debug message
        puts "[DEBUG] #{message}" if @options[:debug]
    end
end