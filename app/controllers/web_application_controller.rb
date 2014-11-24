class WebApplicationController < ApplicationController
	protect_from_forgery(with: :exception)
	before_action(:session_check_expired)
	after_action(:session_add_expiry_time)
	private
	def session_check_expired
		@expired = !session[:expiry_time] || Time.zone.parse(session[:expiry_time]).past?
		session.destroy if @expired
	end
	def session_add_expiry_time
		session[:expiry_time] = $session_expiry_time.from_now.to_s
	end
end
