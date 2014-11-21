module StaffMobileApplicationModule
	private
	def check_staff_login
		@user = RegisteredUser.find(session[:user_id])
		@staff = Staff.find(session[:user_id])
	rescue
		error('staff only') if @user
		error('need login')
	end
end
