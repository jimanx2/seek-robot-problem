# Guide to adding new commands

1. First `cd` into `<REPO_DIR>` (REPO_DIR can be assumed as equal to the one in INSTALLATION.md)
   `$ cd <REPO_DIR>`
2. Run the following:
   `$ docker-compose run --rm cli make:command NAME=newcommand`
3. Please follow the instructions to proceed. Sample:  
   ```sh
   $ docker-compose run --rm cli make:command NAME=Newcommand                                                                                              
      Creating network "seek-robot-problem_default" with the default driver
      Creating seek-robot-problem_cli_run ... done
      create  lib/commands/newcommand_command.rb
      create  spec/unit/lib/commands/newcommand_command_spec.rb

      Command file generated successfully. Now you may register this on any Entrypoint (CLIEntrypoint or ApiEntrypoint) like this: 
      # imports the NewcommandCommand class
      require 'commands/newcommand_command'

      # register the command into entrypoint
      @entrypoint.register_command "NEWCOMMAND", NewcommandCommand.new

      # or, if you know the incoming arguments not going to be in standard array format
      # call it like this
      @entrypoint.register_command "NEWCOMMAND", NewcommandCommand.new, (arg_modifier: Proc.new do |arguments|
        # modify the arguments object here
        arguments[0] = 20 # example

        # return arguments object
        arguments
      end)
   ```
4. Once the command has been generated, you need to register the command into both `app/http/server.rb` and `main.rb`
   ```ruby
   class Server < Roda
      ....
      def initialize args={}
            # need to call this because parent class requires arguments
            super args

            # initialize the ApiEntrypoint class
            @api = ApiEntrypoint.new

            @api.register_command "newcommand", executor: NewcommandCommmand.new
            ....
       end
       ....
   end
   ```
5. Restart both server and worker container  
   `$ docker-compose restart server worker`
