class ConveyorConnector
	@conveyor_server = []
	def initialize(conveyor)
		Rails.logger.info { 'ConveyorConnector open port '.fc_n_yellow + conveyor.server_port.to_s.fc_b_yellow + ' to accept conveyor '.fc_n_yellow + conveyor.name.fc_b_yellow + ' connection'.fc_n_yellow }
		thread = Thread.new(conveyor.id, conveyor.server_ip, conveyor.name, conveyor.server_port, TCPServer.new('0.0.0.0', conveyor.server_port)) do |id, ip, name, port, server|
			loop do
				begin
					connection = server.accept
					if connection.remote_address.ip_address == Addrinfo.ip(ip).ip_address || connection.remote_address.ip_address == '127.0.0.1'
						Rails.logger.info { 'ConveyorConnector conveyor '.fc_n_yellow + name.fc_b_yellow + ' connect to port '.fc_n_yellow + port.to_s.fc_b_yellow + ' at '.fc_n_yellow + connection.remote_address.ip_address.fc_b_yellow }
						@conveyor_server[id] = connection
					else
						Rails.logger.info { 'ConveyorConnector someone connect to port '.fc_n_yellow + port.to_s.fc_b_yellow + ' at '.fc_n_yellow + connection.remote_address.ip_address.fc_b_yellow + ' not match '.fc_n_yellow + Addrinfo.ip(ip).ip_address.fc_b_yellow }
						connection.close
					end
				rescue
					Rails.logger.error { 'ConveyorConnector error occurred'.fc_n_yellow }
					Rails.logger.error { "  #{$!.message}".fc_b_yellow }
					Rails.logger.error { $!.backtrace.collect { |x| "    #{x}".fc_n_yellow} }
				end
			end
		end
		thread.abort_on_exception = true
	end

	class << self
		attr_accessor(:conveyor_server)
		def start
			Rails.logger.info { 'ConveyorConnector open ports to accept conveyor connection'.fc_n_yellow }
			Conveyor.where(passive: true).each { |x| new(x) }
		end
	end

end
