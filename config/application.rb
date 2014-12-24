require(File.expand_path('../boot', __FILE__))

require('rails/all')

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require(File.expand_path('../config', __FILE__))

module FYP
	class Application < Rails::Application
		config.after_initialize do
			if defined?(Rails::Server)
				puts('open ports to accept conveyor connection')
				$conveyor_server = []
				Conveyor.where(passive: true).each do |conveyor|
					puts("open port '#{conveyor.server_port}' to accept conveyor '#{conveyor.name}' connection")
					Thread.new(conveyor.id, conveyor.server_ip, conveyor.name, conveyor.server_port, TCPServer.new('0.0.0.0', conveyor.server_port)) do |id, ip, name, port, server|
						loop do
							connection = server.accept
							if connection.remote_address.ip_address == Addrinfo.ip(ip).ip_address || connection.remote_address.ip_address == '127.0.0.1'
								puts("conveyor '#{name}' connect to port '#{port}' at '#{connection.remote_address.ip_address}'")
								$conveyor_server[id] = connection
							else
								puts("someone connect to port '#{port}' at '#{connection.remote_address.ip_address}' not match '#{Addrinfo.ip(ip).ip_address}'")
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
		super(error)
		@detail = hash
	end
	def detail
		@detail
	end
end

class NotInDevelopmentModeError < StandardError
	def initialize
		super('This method can only call in development mode.')
	end
end

class ParameterError < StandardError
	def initialize(parameter = nil)
		if parameter
			super("Invalid parameter \"#{parameter}\"")
		else
			super('There is an invalid parameter')
		end
	end
end

def error(*arg)
	raise(Error.new(*arg))
end
