namespace :make do
    desc "Generate a new command class"
    task :command do 
        raise 'Please set the NAME environment value' if ENV['NAME'].nil? || ENV['NAME'].empty?
        CommandGenerator.start([ENV['NAME']])
    end
end