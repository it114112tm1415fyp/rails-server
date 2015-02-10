class ApplicationController < ActionController::Base
	before_action(:session_check_expired)
	after_action(:session_add_expiry_time, except: :make_session_expired)
	def destroy_session
		only_available_at_development
		view_session
		session.destroy
	end
	def edit_session
		only_available_at_development
		params_require(:key, :value)
		session[params[:key]] = params[:value]
		view_session
	end
	def make_session_expired
		only_available_at_development
		session[:expiry_time] = $session_expiry_time.ago.to_s
		view_session
	end
	def view_session
		only_available_at_development
		render(text: session.to_hash)
	end
	private
	def only_available_at_development
		raise(NotInDevelopmentModeError) unless Rails.env.development?
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
