require 'exceptions/invalid_direction_exception'
require 'exceptions/outofbound_exception'
require 'redis'
require 'session_driver'
require_relative '../../../http/middlewares/session_middleware'

RSpec.describe SessionMiddleware do
    class AppMock 
        def call(env)
            return true
        end
    end
    let(:middleware) { SessionMiddleware.new(AppMock.new) }

    describe "#initialize" do
        it "accepts only one argument" do
            expect { SessionMiddleware.new(:app, :another) }.to raise_error(ArgumentError)
        end

        it "sets the app instance" do
            expect(middleware.app).to_not eq(nil)
        end

        it "sets the session_driver object" do
            expect(middleware.session_driver).to_not eq(nil)
        end
    end

    describe "#call" do
        it "accepts only one argument" do
            expect { middleware.call(:env, :other) }.to raise_error(ArgumentError)
        end

        it "sets the env 'session_driver' value" do
            env = Hash.new
            middleware.call(env)
            expect(env['session_driver']).to_not eq(nil)
        end
    end
end