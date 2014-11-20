require(File.expand_path('../boot', __FILE__))

require('rails/all')

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require(File.expand_path('../config', __FILE__))

module FYP
	class Application < Rails::Application
		$server_host = Addrinfo.ip($server_host).ip_address
		config.after_initialize do
			if defined?(Rails::Server)
				puts('open ports to accept conveyor connection')
				$conveyor_server = []
				Conveyor.where(passive: true).each do |conveyor|
					puts("open port '#{conveyor.server_port}' to accept conveyor '#{conveyor.name}' connection")
					Thread.new(conveyor.id, Addrinfo.ip(conveyor.server_ip).ip_address, conveyor.name, conveyor.server_port, TCPServer.new($server_host, conveyor.server_port)) do |id, ip, name, port, server|
						loop do
							connection = server.accept
							if connection.remote_address.ip_address == ip || connection.remote_address.ip_address == $server_host
								puts("conveyor '#{name}' connect to port '#{port}' at '#{connection.remote_address.ip_address}'")
								$conveyor_server[id] = connection
							else
								puts("someone connect to port '#{port}' at '#{connection.remote_address.ip_address}' not match '#{ip}'")
								connection.close
							end
						end
					end
				end
			end
		end
	end
end

class Error < Exception
	def initialize(error, hash={})
		@error = error
		@detail = hash
	end
	def detail
		@detail
	end
	def error
		@error
	end
end

class NotInDevelopmentModeError < StandardError
	def initialize
		super('This method can only call in development mode.')
	end
end

class ParameterError < StandardError
end
def error(*arg)
	raise(Error.new(*arg))
end
