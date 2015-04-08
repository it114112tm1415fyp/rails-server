class RailsServer
	class << self
		# @return [Class]
		def server_type
			return @server_type if @server_type
			return nil unless defined?(Rails::Server)
			ObjectSpace.each_object(Rails::Server) do |x|
				@server_type = x.server
			end
			@server_type
		end
		# @return [Object]
		def web_server
			@web_server ||= server_type.instance_variable_get(:@server)
		end
		# @param [Proc] block
		# @return [Meaningless]
		def on_standby(&block)
			return unless defined?(Rails::Server)
			raise(CalledTwiceError) if @on_stand_by_thread
			@on_stand_by_thread = Thread.new do
				sleep(0.02) until standby
				sleep(0.2)
				block.call
			end
		end
		# @return [FalseClass, TrueClass]
		def standby
			return false unless web_server
			case web_server
				when WEBrick::HTTPServer
					web_server.status == :Running
				else
					puts 'Do not know how to check weather the server was standby, please specify how to do it in "boot/rails_server.rb"'.red.on_light_yellow
					sleep(2)
			end
		end
	end
end
