# Guide to adding new commands

1. First `cd` into `<REPO_DIR>` (REPO_DIR can be assumed as equal to the one in INSTALLATION.md)
   `$ cd <REPO_DIR>`
2. Run the following:
   `$ docker-compose run --rm cli make:command NAME=newcommand`
3. Please follow the instructions to proceed.
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
