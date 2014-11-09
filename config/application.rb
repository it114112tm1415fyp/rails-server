require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FYP
	class Application < Rails::Application
		config.after_initialize do
			if defined?(Rails::Server)
				puts('open ports to accept conveyor connection')
				$conveyor_server = []
				for conveyor in Conveyor.where(passive: true)
					puts("open port '#{conveyor.server_port}' to accept conveyor '#{conveyor.name}' connection")
					Thread.new(conveyor.id, Addrinfo.ip(conveyor.server_ip), conveyor.name, conveyor.server_port, TCPServer.new('it114112tm1415fyp1.redirectme.net', conveyor.server_port)) do |id, ip, name, port, server|
						loop do
							connection = server.accept
							if connection.remote_address.ip_address == ip.ip_address
								puts("conveyor '#{name}' connect to port '#{port}' at '#{connection.remote_address.ip_address}'")
								$conveyor_server[id] = connection
							else
								puts("someone connect to port '#{port}' at '#{connection.remote_address.ip_address}' not match '#{ip.ip_address}'")
								connection.close
							end
						end
					end
				end
				puts('after_initialize done')
			end
		end
	end
end
