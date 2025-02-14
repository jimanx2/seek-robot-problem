require 'roda'
require 'json'

module Http
    class Server < Roda
        route do |r|
            r.get 'api/hello' do
                { message: 'Hello, world!' }.to_json
            end
            
            r.post 'api/greet' do
                data = JSON.parse(r.body.read)
                { message: "Hello, #{data['name']}!" }.to_json
            end         
        end
    end
end