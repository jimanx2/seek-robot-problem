unless @options[:repl].nil?
    Signal.trap("INT") do
        puts "\nUse 'exit' to quit the REPL."  # Custom message
        print "TABLE> "
    end
end