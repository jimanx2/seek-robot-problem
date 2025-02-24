# RSpec Test Output

```sh
$ docker-compose run --rm cli spec
Creating seek-robot-problem_cli_run ... done
/usr/local/bin/ruby -I/srv/app/vendor/bundle/ruby/3.4.0/gems/rspec-core-3.13.3/lib:/srv/app/vendor/bundle/ruby/3.4.0/gems/rspec-support-3.13.2/lib /srv/app/vendor/bundle/ruby/3.4.0/gems/rspec-core-3.13.3/exe/rspec --pattern spec/\*\*\{,/\*/\*\*\}/\*_spec.rb --format documentation

Http::Server
  POST /api/robot/place
    with valid request parameters
      responds with a success with code 200
      sets a table of size 5x5
      sets a robot with position and direction = 1,1,NORTH
    with invalid face direction
      responds with a failure with code 400
      does not create any table or robot
    with out of bound coordinate
      responds with a failure with code 400
      does not modify current robot position or direction
  POST /api/robot/left
    responds with a success with code 200
    changed the robot direction accordingly
  POST /api/robot/right
    responds with a success with code 200
    changed the robot direction accordingly
  POST /api/robot/move
    the robot is not at the table edge
      responds with a success with code 200
      moved the robot a unit forward
    the robot is at the table edge
      should return failed with status 400
      should keep the robot at same position
  GET /api/robot/report
    responds with a success with code 200 along with current robot position & direction
  Race condition test
    with 5 simultaneus move command
      should accept the first command
      should reject the others
      should report the correct robot position after all requests processed
      should queue the remaining requests to worker
      should report the updated robot position after all queue processed

Debug
  #debug
    should be able to call debug()
    should print debug message when command line options :debug is true
    should not print debug message when command line options :debug is not set or false

InputParser
  #parse
    should be able to call parse()
    given one word input
      should return [command, []]
    given two words input
      should return [command, [args1]]
    given two words input with second word delimited with comma (,)
      should return [command, [args1,args2]]
    given two words input with second word delimited with comma (,) with variable spacing
      should return [command, [args1,args2,args3,args4]]

Command
  #execute
    accepts two arguments

HelloCommand
  #initialize
    should inherit the command class

LeftCommand
  #initialize
    should inherit the command class
  #execute
    Invokes robot.left()

MoveCommand
  #initialize
    should inherit the command class
  #execute
    Invokes robot.move()
    rejects invalid position

NewcommandCommand
  #initialize
    should inherit the command class

PlaceCommand
  #initialize
    should inherit the command class
  #execute
    Invokes robot.place()
    rejects invalid direction

ReportCommand
  #initialize
    should inherit the command class
  #execute
    Invokes robot.report()

RightCommand
  #initialize
    should inherit the command class
  #execute
    Invokes robot.right()

ApiEntrypoint
  #initialize
    should inherit the Entrypoint class
  #process
    handles a valid request (HELLO)
    rejects an invalid request (HOLA)

CLIEntrypoint
  #initialize
    should inherit the Entrypoint class
  #process
    handles a valid request (HELLO)
    rejects an invalid request (HOLA)

Robot
  #initialize
    initializes with no position and direction
  #place
    when given valid parameters
      sets the position and direction correctly
    when given invalid x-coordinate
      raises an OutofboundException
    when given invalid y-coordinate
      raises an OutofboundException
    when given non integer x and y coordinate
      raises an InvalidArgumentException
    when given invalid direction
      raises an InvalidDirectionException
  #left
    ignores the command if there is no direction yet
    turns the robot 90 degrees counter-clockwise
    wraps around when turning left from NORTH
  #right
    ignores the command if there is no direction yet
    turns the robot 90 degrees clockwise
    wraps around when turning right from WEST
  #move
    when position is set
      moves the robot one unit forward
      raises an OutofboundException when trying to move out of bounds
    when position is not set
      does not move the robot
  #report
    when position is set
      returns the correct position and direction
    when position is not set
      returns nil

SessionDriver
  #initialize
    assigns @redis object with new Redis
  #from
    expects one argument
    when given a session_id
      return new Session object

SessionMiddleware
  #initialize
    accepts only one argument
    sets the app instance
    sets the session_driver object
  #call
    accepts only one argument
    sets the env 'session_driver' value

Session
  #initialize
    should have :id, :loaded_objects, and :redis property
    has loaded_objects as empty Hash
  #get
    redis does not have requested key
      should return the fallback value
    redis has the requested key, but nil or empty
      should return the fallback value
    redis has the requested key, and not a valid YAML
      should return the fallback value

Table
  #initialize
    sets default width to 5
    sets default length to 5
    initializes an empty robots array
  #add
    when adding a robot
      adds the robot to the table's robots array
      does not add the same robot twice

Finished in 0.35913 seconds (files took 0.40607 seconds to load)
85 examples, 0 failures
```
