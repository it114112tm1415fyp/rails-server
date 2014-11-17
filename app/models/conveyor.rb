class Conveyor < ActiveRecord::Base
	belongs_to(:address)
	validates_numericality_of(:server_port, greater_than_or_equal_to: 0, less_than: 65536)

	class << self
		def get_list
			all.collect { |x| x.name }.sort
		end
		def send_message(conveyor, message)
			if conveyor.passive
				socket = $conveyor_server[conveyor.id]
				raise unless socket
			else
				socket = TCPSocket.new(conveyor.server_ip, conveyor.server_port)
			end
			begin
				Timeout.timeout(2) { socket.puts(message) }
				Timeout.timeout(2) { socket.gets }
			rescue
				$conveyor_server[conveyor.id] = socket.close
				raise
			end
		rescue
			error('offline')
		end
	end

	class Control
		ExpiredTime = 10
		@@control = []
		attr_reader(:user_id)
		attr_reader(:time)
		def initialize(user_id)
			@user_id = user_id
			@time = Time.now
		end
		def using?
			Time.now - @time <= ExpiredTime
		end
		class << self
			def get_control(conveyor, user_id)
				control = @@control[conveyor.id]
				error('other user is using') if control && control.using? && control.user_id != user_id
				@@control[conveyor.id] = new(user_id)
			end
		end
	end

end
