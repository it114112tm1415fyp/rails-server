module ConveyorHelper

	class << self

		def send_message(conveyor_name, message)
			conveyor = Conveyor.find_by_name(conveyor_name)
			return error('conveyor not exist') unless conveyor
			if conveyor.passive
				socket = $conveyor_server[conveyor.id]
			else
				begin
					socket = TCPSocket.new(conveyor.server_ip, conveyor.server_port)
				rescue
					socket = nil
				end
			end
			if socket
				socket.puts(message)
				success(message: socket.gets)
			else
				error('offline')
			end
		end

		def get_list
			success(list: Conveyor.all.collect { |x| x.name }.sort)
		end

	end

end
