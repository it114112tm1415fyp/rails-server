module CustomerMobileApplicationModule
	private
	def check_customer_login
		@user = RegisteredUser.find(session[:user_id])
		raise unless @user
	rescue
		error('need login')
	end
end
