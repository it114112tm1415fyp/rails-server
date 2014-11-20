class CustomerAccountController < CustomerMobileApplicationController
	skip_before_action(:check_login, only: [:login, :register])
	def login
		params_require(:username, :password)
		@client = Client.login(params[:username], params[:password])
		add_user_information
	end
	def register
		params_require(:username, :password, :name, :email, :phone, :address)
		@client = Client.register(params[:username], params[:password], params[:name], params[:email], params[:phone], params[:address])
		add_user_information
	end
	def edit_profile
		params_require(:password)
		@client.edit_profile(params)
		add_user_information
	end
	private
	def add_user_information
		session[:user_id] = @client.id
		json_response_success(id: @client.id, name: @client.name, email: @client.email, phone: @client.phone, addresses: @client.specify_addresses.collect { |x| x.address }, register_time: @client.created_at, last_modify_time: @client.updated_at)
	end
end
