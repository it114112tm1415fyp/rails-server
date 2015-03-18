class AccountController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	before_action(:check_customer_login, except: [:customer_login, :logout, :register, :staff_login])
	after_action(:add_user_information, except: [:find_user_info, :logout])
	def customer_login
		params_require(:username, :password)
		@customer = RegisteredUser.login(params[:username], params[:password])
	end
	def edit_profile
		params_require(:password)
		@customer.edit_profile(params[:password], params[:new_password], params[:name], params[:email], params[:phone], params[:addresses])
	end
	def find_user_info
		params_require(:username, :phone)
		json_response_success(RegisteredUser.find_user_info(params[:username], params[:phone]))
	end
	def logout
		session.destroy
	end
	def register
		params_require(:username, :password, :name, :email, :phone, :addresses)
		@customer = Client.register(params[:username], params[:password], params[:name], params[:email], params[:phone], params[:addresses])
	end
	def staff_login
		params_require(:username, :password)
		@staff = Staff.login(params[:username], params[:password])
		@customer = @staff
	end
	private
	def add_user_information
		session[:user_id] = @customer.id
		@json_response[:id] = @customer.id
		@json_response[:name] = @customer.name
		@json_response[:email] = @customer.email
		@json_response[:phone] = @customer.phone
		@json_response[:addresses] = @customer.specify_addresses.collect { |x| {id: x.id, address: x.address, region: {id: x.region.id, name: x.region.name}} }
		@json_response[:workplace] = {id: @staff.workplace.id, name: @staff.workplace.short_name} if @staff
		@json_response[:register_time] = @customer.created_at
		@json_response[:last_modify_time] = @customer.updated_at
	end
end
