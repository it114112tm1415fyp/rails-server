class CustomerMobileApplicationController < MobileApplicationController
	before_action(:check_login)
	private
	def check_login
		@user = User.find(session[:user_id])
		raise unless %w(staff client).include?(@user.user_type.name)
	rescue
		error('need login')
	end
end