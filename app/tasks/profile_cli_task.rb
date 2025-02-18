namespace :profiling do 
    desc "Performance test for CLI app" 
    task :cli do 
        require 'ruby-prof'

        @max_threads = ENV['NUM_THREAD'].nil? ? 100 : ENV['NUM_THREAD'].to_i

        def to_profile
            
        end

        def profile_task(mode)
            RubyProf::Profile.profile do
                (0..@max_threads).each do
                    @ARGV = ['main', '-f', 'spec/fixtures/InputFile']
                    require './main'
                end
            end
        end
        
        def print_top_results(result, title, metric, memory_in_kb = false)
            puts "\n=== #{title} ==="

            # Get the methods from the first thread
            methods = result.threads.first.methods.sort_by { |method| -method.send(metric) }

            # Calculate total value for the metric (CPU or Memory)
            total_value = result.threads.first.methods.sum { |method| method.send(metric) }
            total_value = memory_in_kb ? total_value.to_f / 1024 : total_value
            unit = memory_in_kb ? "KB" : "Seconds"
            
            # Print the total value
            puts "Total #{title.split.first} usage: #{total_value.round(2)} #{unit}"

            # Print top 10 methods
            methods.filter {|x| !x.full_name.include?('Thread') }.each do |method|
                value = memory_in_kb ? method.send(metric).to_f / 1024 : method.send(metric)
                calls = method.called  # Number of calls for this method
                puts "#{method.full_name.ljust(40)} | Calls: #{calls.to_s.ljust(6)} | #{value.round(2)} #{unit}"
            end
        end
        
        puts "Running performance profiling."
        puts "Threads: #{@max_threads}."
        print "Please be patient..."

        cpu_result = profile_task(RubyProf::PROCESS_TIME)
        mem_result = profile_task(RubyProf::MEMORY)      
        
        print "DONE\n"

        print_top_results(cpu_result, "CPU Usage", :self_time)
        print_top_results(mem_result, "Memory Usage", :self_time, true)
    end
end