module CustomerMobileApplicationModule
	private
	def check_customer_login
		@customer = RegisteredUser.find(session[:user_id])
		raise unless @customer
	rescue
		error('Connection expired') if @expired
		error('Login require')
	end
end
