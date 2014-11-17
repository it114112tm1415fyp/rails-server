class CustomerAccountController < CustomerMobileApplicationController
	skip_before_action(:check_login, only: [:login, :register])
	def login
		params_require(:username, :password)
		@user = User.customer_login(params[:username], params[:password])
		add_user_information
	end
	def register
		params_require(:username, :password, :name, :email, :phone, :address)
		@user = User.customer_register(params[:username], params[:password], params[:name], params[:email], params[:phone], params[:address])
		add_user_information
	end
	def edit_profile
		params_require(:password)
		User.edit_profile(@user, params)
		add_user_information
	end
	private
	def add_user_information
		session[:user_id] = @user.id
		json_response_success(id: @user.id, name: @user.name, email: @user.email, phone: @user.phone, addresses: @user.addresses.collect { |x| x.address }, created_at: @user.created_at, updated_at: @user.updated_at)
	end
end
