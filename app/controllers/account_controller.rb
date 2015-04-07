class AccountController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	before_action(:check_customer_login, except: [:customer_login, :logout, :register, :staff_login])
	after_action(:add_user_information, except: [:find_user_info, :logout])
	def customer_login
		params_require(:username, :password)
		@customer = RegisteredUser.login(params[:username], params[:password])
		response_success(@customer)
	end
	def edit_profile
		params_require(:password)
		@customer.edit_profile(params[:password], params[:new_password], params[:name], params[:email], params[:phone], params[:addresses])
		response_success(@customer)
	end
	def find_user_info
		params_require(:username, :phone)
		response_success(RegisteredUser.find_user_info(params[:username], params[:phone]))
	end
	def logout
		session.destroy
		response_success(@customer)
	end
	def register
		params_require(:username, :password, :name, :email, :phone, :addresses)
		@customer = Client.register(params[:username], params[:password], params[:name], params[:email], params[:phone], params[:addresses])
		response_success(@customer)
	end
	def staff_login
		params_require(:username, :password)
		@staff = Staff.login(params[:username], params[:password])
		@customer = @staff
		response_success(@customer)
	end
	private
	def add_user_information
		session[:user_id] = @customer.id
	end
end
