require 'exceptions/invalid_direction_exception'
require 'exceptions/outofbound_exception'
require 'redis'
require 'session'
require 'session_driver'

RSpec.describe SessionDriver do
    let(:redis_mock) { instance_double(Redis) }
    let(:driver) { SessionDriver.new }

    before do
        allow(Redis).to receive(:new).and_return(redis_mock)
    end

    describe "#initialize" do
        it "assigns @redis object with new Redis" do 
            expect(driver.redis).to_not eq(nil)
        end
    end

    describe "#from" do 
        it "expects one argument" do 
            expect { driver.from }.to raise_error(ArgumentError)
        end

        context "when given a session_id" do 
            it "return new Session object" do 
                session = driver.from("a-session-id")
                expect(session.id).to eq("a-session-id")
                expect(session.redis).to eq(driver.redis)
            end
        end
    end
end