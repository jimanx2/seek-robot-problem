require 'redis'
require 'resque'
require 'resque_spec'
require 'mock_redis'
require 'rspec/roda'
require_relative '../../http/server'
require_relative '../../http/jobs/command_executor_job'

RSpec.describe Http::Server, roda: :app, integration: true do 
    def app
        Http::Server.freeze.app
    end

    before(:each) do
        @mock_redis = MockRedis.new
        allow(Redis).to receive(:new).and_return(@mock_redis)
        ResqueSpec.reset!

        header 'Content-Type', 'application/json'
        post '/api/robot/place', '{"x":"1","y":"1","direction":"NORTH"}'
        @place_response = last_response
    end

    describe "POST /api/robot/place" do
        context "with valid request parameters" do 
            it "responds with a success with code 200" do 
                expect(@place_response.status).to eq(200)
                expect(@place_response.body).to eq('{"status":"success","message":"Command completed successfully"}')
            end

            it "sets a table of size 5x5" do
                session_id = @place_response.headers['x-session-id']
                session = app.session_driver.from(session_id)

                table = session.get('table', Proc.new { nil })
                expect([table.width, table.length]).to eq([5,5])
            end

            it "sets a robot with position and direction = 1,1,NORTH" do
                session_id = @place_response.headers['x-session-id']
                session = app.session_driver.from(session_id)

                robot = session.get('robot', Proc.new { nil })
                expect([robot.x, robot.y, robot.directions[robot.direction]]).to eq([1,1,"NORTH"])
            end
        end

        context "with invalid face direction" do 
            before do 
                post '/api/robot/place', '{"x":"1","y":"1","direction":"NO"}'
            end

            it "responds with a failure with code 400" do 
                expect(last_response.status).to eq(400)
                expect(last_response.body).to eq('{"status":"error","message":"This direction is not valid"}')
            end

            it "does not create any table or robot" do 
                session_id = last_response.headers['x-session-id']
                session = app.session_driver.from(session_id)

                robot = session.get('robot', Proc.new { nil })
                table = session.get('table', Proc.new { nil })

                expect(robot).to eq(nil)
                expect(table).to eq(nil)
            end
        end

        context "with out of bound coordinate" do 
            before do 
                post '/api/robot/place', '{"x":"-1","y":"6","direction":"NORTH"}'
            end

            it "responds with a failure with code 400" do 
                expect(last_response.status).to eq(400)
                expect(last_response.body).to eq('{"status":"error","message":"This placement is out of bound"}')
            end

            it "does not modify current robot position or direction" do 
                session_id = @place_response.headers['x-session-id']
                session = app.session_driver.from(session_id)

                robot = session.get('robot', Proc.new { nil })

                expect([robot.x, robot.y, robot.direction]).to eq([1,1,0])
            end
        end
    end

    describe "POST /api/robot/left" do
        before do
            header 'X-Session-Id', @place_response.headers['x-session-id']
            header 'Content-Type', 'text/plain'
            header 'Content-Length', 0
            post '/api/robot/left'
        end

        it "responds with a success with code 200" do 
            expect(last_response.status).to eq(200)
        end

        it "changed the robot direction accordingly" do 
            session_id = last_response.headers['x-session-id']
            session = app.session_driver.from(session_id)

            robot = session.get('robot', Proc.new { nil })

            expect(robot.direction).to eq(3)
        end
    end

    describe "POST /api/robot/right" do
        before do
            header 'X-Session-Id', @place_response.headers['x-session-id']
            header 'Content-Type', 'text/plain'
            header 'Content-Length', 0
            post '/api/robot/right'
        end

        it "responds with a success with code 200" do 
            expect(last_response.status).to eq(200)
        end

        it "changed the robot direction accordingly" do 
            session_id = last_response.headers['x-session-id']
            session = app.session_driver.from(session_id)

            robot = session.get('robot', Proc.new { nil })

            expect(robot.direction).to eq(1)
        end
    end

    describe "POST /api/robot/move" do
        before do
            header 'X-Session-Id', @place_response.headers['x-session-id']
            header 'Content-Type', 'text/plain'
            header 'Content-Length', 0
            post '/api/robot/move'
        end

        it "responds with a success with code 200" do 
            expect(last_response.status).to eq(200)
        end

        it "moved the robot a unit forward" do 
            session_id = last_response.headers['x-session-id']
            session = app.session_driver.from(session_id)

            robot = session.get('robot', Proc.new { nil })

            expect(robot.y).to eq(2)
        end
    end

    describe "GET /api/robot/report" do
        before do
            header 'X-Session-Id', @place_response.headers['x-session-id']
            header 'Content-Type', 'text/plain'
            get '/api/robot/report'
        end

        it "responds with a success with code 200 along with current robot position & direction" do 
            expect(last_response.status).to eq(200)
            expect(last_response.body).to eq('{"status":"success","message":{"x":1,"y":1,"direction":"NORTH"}}')
        end
    end

    describe "Race condition test" do 
        let(:maxqueue) { 3 }
        before do 
            # place the robot 
            header 'Content-Type', 'application/json'
            post '/api/robot/place', '{"x":"1","y":"1","direction":"NORTH"}'
            @base_response = last_response
        end
        
        context "with 5 simultaneus move command" do 
            before do
                threads = []
                @results = {}
                (0..maxqueue).each do |i|
                    threads << Thread.new do 
                        header 'X-Session-Id', @base_response.headers['x-session-id']
                        header 'Content-Type', 'application/json'
                        post '/api/robot/move', { delay: rand(1.5) }.to_json

                        @results[i] = { status: last_response.status, body: last_response.body }
                    end
                end
                threads.map(&:join)
            end

            it "should accept the first command" do 
                expect(@results[0][:status]).to eq(200)
            end

            it "should reject the others" do 
                all_rejected = true
                (1..maxqueue).each do |i|
                    result = @results[i]
                    all_rejected &&= result[:status] != 200
                end
                expect(all_rejected).to eq(true)
            end

            it "should report the correct robot position after all requests processed" do 
                session_id = @base_response.headers['x-session-id']
                session = app.session_driver.from(session_id)

                robot = session.get('robot', Proc.new { nil })

                expect(robot.y).to eq(2)
            end

            it "should queue the remaining requests to worker" do 
                expect(CommandExecutorJob).to have_queue_size_of(maxqueue)
            end

            it "should report the updated robot position after all queue processed" do 
                session_id = @base_response.headers['x-session-id']
                session = app.session_driver.from(session_id)

                (2..maxqueue).each do |i|
                    CommandExecutorJob
                        .with_session(session)
                        .perform(session_id, "MOVE")
                end

                robot = session.get('robot', Proc.new { nil })

                expect(robot.y).to eq(4)
            end
        end
    end
end