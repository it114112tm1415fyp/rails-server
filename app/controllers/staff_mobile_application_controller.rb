class StaffMobileApplicationController < MobileApplicationController
	before_action(:check_login)
	private
	def check_login
		user = RegisteredUser.find(session[:user_id])
		@staff = Staff.find(session[:user_id])
	rescue
		error('staff only') if user
		error('need login')
	end
end
