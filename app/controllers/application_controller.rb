class ApplicationController < ActionController::Base
	before_action(:session_check_expired)
	after_action(:session_add_expiry_time)
	private
	def only_available_at_development
		raise(NotInDevelopmentModeError) unless ENV['rails_env'] == 'development'
	end
	def params_require(*keys)
		keys.each { |x| params.require(x) }
	end
	def params_exist(*keys)
		keys.all? { |x| params.key?(x) }
	end
	def session_add_expiry_time
		session[:expiry_time] = $session_expiry_time.from_now.to_s
	end
	def session_check_expired
		@expired = !session[:expiry_time] || Time.zone.parse(session[:expiry_time]).past?
		session.destroy if @expired
	end
end
