require 'thor'

class CommandGenerator < Thor::Group
  include Thor::Actions

  argument :command
  argument :command_body, :optional => true, :default => "# TODO: Replace this with real implementation"
  argument :spec_path, :optional => true, :default => "spec"

  def self.source_root
    File.dirname(__FILE__) + '/stub'
  end

  def create_command_file
    if (
      template("{command}_command.rb.tt", File.dirname(__FILE__) + "/#{command.downcase}_command.rb") &&
      template("spec/{command}_command_spec.rb.tt", spec_path + "/unit/lib/commands/#{command.downcase}_command_spec.rb")
    )
      say "\nCommand file generated successfully. Now you may register this on any Entrypoint (CLIEntrypoint or ApiEntrypoint) " +
        "like this: \n\n", :green
      say <<-EOF
      # imports the #{command.capitalize}Command class
      require 'commands/#{command.downcase}_command'

      # register the command into entrypoint
      @entrypoint.register_command "#{command.upcase}", #{command.capitalize}Command.new

      # or, if you know the incoming arguments not going to be in standard array format
      # call it like this
      @entrypoint.register_command "#{command.upcase}", #{command.capitalize}Command.new, (arg_modifier: Proc.new do |arguments|
        # modify the arguments object here
        arguments[0] = 20 # example

        # return arguments object
        arguments
      end)
EOF
    end
  end
end