class ApplicationController < ActionController::Base
	before_action(:session_check_expired)
	after_action(:session_add_expiry_time, except: :make_session_expired)
	private
	# @param [Array<Symbol>] keys
	# @return [Meaningless]
	def params_require(*keys)
		keys.each { |x| params.require(x) }
	end
	# @return [FalseClass, TrueClass]
	def params_exist(*keys)
		keys.all? { |x| params.key?(x) }
	end
	def session_add_expiry_time
		session[:expiry_time] = $session_expiry_time.from_now.to_s
	end
	def session_check_expired
		return if Socket.ip_address_list.any? { |x| x.ip_address == request.remote_ip } || Addrinfo.ip($dns_address).ip_address == request.remote_ip
		@expired = !session[:expiry_time] || Time.zone.parse(session[:expiry_time]).past?
		session.destroy if @expired
	end
end
