namespace(:debug) do
	namespace(:conveyor) do
		task(:active) do
			port = (ENV['port'] || 8001).to_i
			server = TCPServer.new('localhost', port)
			puts("open port '#{port}' to accept")
			begin
				loop do
					connection = server.accept
					puts("FYP server connect from '#{connection.remote_address.ip_address}'")
					puts("receive : #{connection.gets}")
					status = ActiveSupport::JSON.encode({ch: Array.new(4) { rand(6) }, cr: Array.new(2) { rand(3) }, mr: rand(3), st: Array.new(8) { rand(2) }})
					connection.puts(status)
					puts("send : #{status}")
					connection.close
					puts('connection closed')
				end
			rescue Exception
				retry
			end
		end
		task(:passive) do
			port = (ENV['port'] || 8001).to_i
			begin
				connection = TCPSocket.new('localhost', port)
				puts("connected to server'")
				loop do
					puts("receive : #{connection.gets}")
					status = ActiveSupport::JSON.encode({ch: Array.new(4) { rand(6) }, cr: Array.new(2) { rand(3) }, mr: rand(3), st: Array.new(8) { rand(2) }})
					connection.puts(status)
					puts("send : #{status}")
				end
			rescue Exception
				retry
			end
		end
	end
end
