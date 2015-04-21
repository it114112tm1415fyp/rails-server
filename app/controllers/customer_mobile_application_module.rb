module CustomerMobileApplicationModule
	private
	def check_customer_login
		@customer = RegisteredUser.find(session[:user_id])
		raise unless @customer
		@staff = @customer if @customer.is_a?(Staff)
	rescue
		error('Connection expired') if @expired
		error('Login require')
	end
end
