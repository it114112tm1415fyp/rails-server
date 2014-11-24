class Conveyor < ActiveRecord::Base
	belongs_to(:store_address)
	has_many(:conveyor_control_logs)
	validates_numericality_of(:server_port, greater_than_or_equal_to: 0, less_than: 65536)
	#@return [Hash]
	def get_control(staff, raise_if_error)
		Control.occupy(id, staff.id)
		send_message('', raise_if_error)
	end
	#@return [Hash]
	def send_message(message, raise_if_error)
		if passive
			socket = $conveyor_server[id]
			raise unless socket
		else
			socket = TCPSocket.new(server_ip, server_port)
		end
		begin
			Timeout.timeout(2) { socket.puts(message) }
			result = Timeout.timeout(2) { ActiveSupport::JSON.decode(socket.gets) }
		rescue Timeout::Error
			$conveyor_server[id] = socket.close
			raise
		end
		socket.close unless passive
		return result
	rescue
		$conveyor_server[id] = nil if passive
		socket.close if socket && !socket.closed?
		raise if raise_if_error
		error('offline')
	end

	class << self
		def get_list
			all.collect { |x| x.name }.sort
		end
	end

	class Control
		@control = []
		attr_reader(:staff_id)
		attr_reader(:expiry_time)
		def initialize(staff_id)
			@staff_id = staff_id
			@expiry_time = $conveyor_control_expiry_time.from_now
		end
		def unexpired?
			@expiry_time.past?
		end
		class << self
			def check(conveyor_id, staff_id)
				control = @control[conveyor_id]
				error('need control') unless control && control.unexpired? && control.staff_id == staff_id
			end
			def occupy(conveyor_id, staff_id)
				control = @control[conveyor_id]
				error('other user is using') if control && control.unexpired? && control.staff_id != staff_id
				@control[conveyor_id] = new(staff_id)
			end
		end

	end

end
