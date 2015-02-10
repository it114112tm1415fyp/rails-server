class AccountController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	before_action(:check_customer_login, except: [:customer_login, :staff_login, :register])
	after_action(:add_user_information, except: :find_user_info)
	def customer_login
		params_require(:username, :password)
		@user = RegisteredUser.login(params[:username], params[:password])
	end
	def edit_profile
		params_require(:password)
		@user.edit_profile(params)
	end
	def find_user_info
		params_require(:username, :phone)
		json_response_success(RegisteredUser.find_user_info(params[:username], params[:phone]))
	end
	def register
		params_require(:username, :password, :name, :email, :phone, :addresses)
		@user = Client.register(params[:username], params[:password], params[:name], params[:email], params[:phone], params[:addresses])
	end
	def staff_login
		params_require(:username, :password)
		@user = Staff.login(params[:username], params[:password])
	end
	private
	def add_user_information
		session[:user_id] = @user.id
		@json_response[:id] = @user.id
		@json_response[:name] = @user.name
		@json_response[:email] = @user.email
		@json_response[:phone] = @user.phone
		@json_response[:addresses] = @user.specify_addresses.collect {|x| {address: x.display_name, region: x.region.name}}
		@json_response[:register_time] = @user.created_at
		@json_response[:last_modify_time] = @user.updated_at
	end
end
