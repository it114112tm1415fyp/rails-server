class CustomerAccountController < CustomerMobileApplicationController
	skip_before_action(:check_login, only: [:login, :register])
	def login
		params_require(:username, :password)
		user = User.customer_login(params[:username], params[:password])
		session[:user_id] = user.id
		@json_response[:name] = user.name
		@json_response[:email] = user.email
		@json_response[:phone] = user.phone
		@json_response[:addresses] = user.addresses.collect{ |x| x.name }
		@json_response[:created_at] = user.created_at
		@json_response[:updated_at] = user.updated_at
	end
	def register
		params_require(:username, :password, :name, :email, :phone, :address)
		session[:user_id] = User.customer_register(params[:username], params[:password], params[:name], params[:email], params[:phone], params[:address]).id
	end
end
