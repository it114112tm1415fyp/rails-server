class Conveyor < ActiveRecord::Base
	belongs_to(:store)
	validates_numericality_of(:server_port, greater_than_or_equal_to: 0, less_than: 65536)
	# @param [Staff] staff
	# @param [FalseClass, TrueClass] raise_if_error
	# @return [Hash]
	def get_control(staff, raise_if_error)
		ConveyorControlling.occupy(id, staff.id)
		send_message('', raise_if_error)
	end
	# @param [String] message
	# @param [FalseClass, TrueClass] raise_if_error
	# @return [Hash]
	def send_message(message, raise_if_error)
		if passive
			socket = $conveyor_server[id]
			raise unless socket
		else
			socket = TCPSocket.new(server_ip, server_port)
		end
		begin
			Timeout.timeout(2) { socket.puts(message) }
			nil until (result = socket.gets) != "\r\n"
			result = Timeout.timeout(2) {ActiveSupport::JSON.decode(result)}
		rescue Timeout::Error
			$conveyor_server[id] = socket.close
			raise
		end
		socket.close unless passive
		return result
	rescue Exception
		$conveyor_server[id] = nil if passive
		socket.close if socket && !socket.closed?
		raise if raise_if_error
		error('offline')
	end

	class << self
		# @return [Array<Hash>]
		def get_list
			all.collect { |x| {id: x.id, name: x.name} }
		end
	end

end
