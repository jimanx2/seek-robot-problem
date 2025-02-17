require 'exceptions/invalid_direction_exception'
require 'exceptions/outofbound_exception'
require 'redis'
require 'yaml'
require 'session'
require 'session_driver'

RSpec.describe Session do
    let(:redis_mock) { instance_double(Redis) }
    let(:session) { Session.new(Redis.new, "a-session-id") }

    before do
        allow(Redis).to receive(:new).and_return(redis_mock)
    end

    describe "#initialize" do 
        it "should have :id, :loaded_objects, and :redis property" do 
            expect(session).to respond_to(:id)
            expect(session).to respond_to(:loaded_objects)
            expect(session).to respond_to(:redis)
        end

        # it "has valid redis property" do 
        #     expect(session.redis).to be_a()
        # end

        it "has loaded_objects as empty Hash" do 
            expect(session.loaded_objects).to be_a(Hash)
            expect(session.loaded_objects).to eq({})
        end
    end

    describe "#get" do 
        context "redis does not have requested key" do
            it "should return the fallback value" do
                allow(redis_mock).to receive(:exists).with('{session:a-session-id}::hey').and_return(false)
                allow(redis_mock).to receive(:get).with('{session:a-session-id}::hey').and_return(nil)
                value = session.get("hey", Proc.new { "fallback" })
                expect(value).to eq("fallback")
            end
        end

        context "redis has the requested key, but nil or empty" do
            it "should return the fallback value" do
                allow(redis_mock).to receive(:exists).with('{session:a-session-id}::hey').and_return(false)
                allow(redis_mock).to receive(:get).with('{session:a-session-id}::hey').and_return(nil)
                value = session.get("hey", Proc.new { "fallback" })
                expect(value).to eq("fallback")

                allow(redis_mock).to receive(:exists).with('{session:a-session-id}::hey').and_return(true)
                allow(redis_mock).to receive(:get).with('{session:a-session-id}::hey').and_return('')
                value = session.get("hey", Proc.new { "fallback" })
                expect(value).to eq("fallback")
            end
        end

        context "redis has the requested key, and not a valid YAML" do
            it "should return the fallback value" do
                allow(redis_mock).to receive(:exists).with('{session:a-session-id}::hey').and_return(true)
                allow(redis_mock).to receive(:get).with('{session:a-session-id}::hey').and_return(nil)
                # expect(STDOUT).to receive(:warn).with('hey does not contain a valid stored object representation (YAML)')
                value = session.get("hey", Proc.new { "fallback" })
                expect(value).to eq("fallback")
            end
        end
    end
end