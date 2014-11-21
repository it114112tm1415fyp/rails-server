class AccountController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	before_action(:check_customer_login, except: [:login, :register])
	def login
		params_require(:username, :password)
		@user = RegisteredUser.login(params[:username], params[:password])
		add_user_information
	end
	def register
		params_require(:username, :password, :name, :email, :phone, :address)
		@user = Client.register(params[:username], params[:password], params[:name], params[:email], params[:phone], params[:address])
		add_user_information
	end
	def edit_profile
		params_require(:password)
		@user.edit_profile(params)
		add_user_information
	end
	private
	def add_user_information
		session[:user_id] = @user.id
		json_response_success(id: @user.id, name: @user.name, email: @user.email, phone: @user.phone, addresses: @user.specify_addresses.collect { |x| x.address }, register_time: @user.created_at, last_modify_time: @user.updated_at)
	end
end
