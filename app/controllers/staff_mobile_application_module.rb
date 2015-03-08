module StaffMobileApplicationModule
	private
	def check_staff_login
		@customer = RegisteredUser.find(session[:user_id])
		@staff = Staff.find(session[:user_id])
	rescue
		error('Connection expired') if @expired
		error('Staff only') if @customer
		error('Login require')
	end
end
