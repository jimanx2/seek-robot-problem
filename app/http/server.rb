module Http
    class Server < Roda
        def initialize args
            super args
            @api = ApiEntrypoint.new
            @table = Table.new(5, 5)
            @robot = Robot.new(@table)
        end

        def handle_robot_request r
            res = @api.process(r) do |executor, arguments|
                executor.execute(@robot, arguments)
            end

            return {
                status: 'success',
                message: res || "Command executed successfully"
            }
        # rescue Exception => e
        #     return {
        #         status: 'error',
        #         message: e.message
        #     }
        end

        plugin :request_headers
        plugin :json

        route do |r|
            r.get 'api/robot/report' do
                r.params['command'] = 'REPORT'
                handle_robot_request(r)
            end
            
            r.post 'api/robot', String do |command|
                r.params['command'] = command.upcase
                handle_robot_request(r)
            end         
        end
    end
end