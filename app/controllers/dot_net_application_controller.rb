class DotNetApplicationController < JsonResponseApplicationController
	before_action(:check_conveyor_ip)
	private
	def check_conveyor_ip
		@conveyor = Conveyor.find { |x| Addrinfo.ip(x.server_ip).ip_address == request.remote_ip }
		p
		error('Conveyor controller only') unless @conveyor || Socket.ip_address_list.any? { |x| x.ip_address == request.remote_ip } || Addrinfo.ip($dns_address).ip_address == request.remote_ip
	end
end
