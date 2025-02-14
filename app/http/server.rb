module Http
    class Server < Roda
        use SessionMiddleware

        def initialize args
            super args
            @api = ApiEntrypoint.new
        end

        def handle_robot_request r
            res = @api.process(r) do |executor, arguments|
                executor.execute(@robot, arguments)
            end
        end

        plugin :request_headers
        plugin :json

        route do |r|
            # get robot here
            session_id = r.headers['X-Session-Id'] || SecureRandom.uuid
            @session   = r.env['session'].from(session_id)
            @table     = @session.get('table', Proc.new { Table.new(5,5) })
            @robot     = @session.get('robot', Proc.new { Robot.new(@table) })

            r.get 'api/robot/report' do
                r.params['command'] = 'REPORT'
                res = handle_robot_request(r, session)

                { :status => 'success', :message => res || "Command completed successfully" }
            rescue Exception => ex
                response.status = 400
                next { :status => 'error', :message => ex.message }
            end
            
            r.post 'api/robot', String do |command|
                r.params['command'] = command.upcase
                res = handle_robot_request(r)

                { :status => 'success', :message => res || "Command completed successfully" }
            rescue Exception => ex
                response.status = 400
                next { :status => 'error', :message => ex.message }
            end 
            
            after do 
                @session.persist
                response['X-Sessiond-Id'] = session_id
            end
        end
    end
end