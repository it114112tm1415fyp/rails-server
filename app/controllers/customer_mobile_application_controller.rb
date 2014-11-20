class CustomerMobileApplicationController < MobileApplicationController
	before_action(:check_login)
	private
	def check_login
		@client = RegisteredUser.find(session[:user_id])
		raise unless @client
	rescue
		error('need login')
	end
end
