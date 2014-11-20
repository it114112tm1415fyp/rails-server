class StaffAccountController < CustomerMobileApplicationController
	skip_before_action(:check_login, only: :login)
	def login
		params_require(:username, :password)
		@staff = Staff.login(params[:username], params[:password])
		add_user_information
	end
	def edit_profile
		params_require(:password)
		@staff.edit_profile(params)
		add_user_information
	end
	private
	def add_user_information
		session[:user_id] = @staff.id
		json_response_success(id: @staff.id, name: @staff.name, email: @staff.email, phone: @staff.phone, addresses: @staff.specify_addresses.collect { |x| x.address }, register_time: @staff.created_at, last_modify_time: @staff.updated_at)
	end
end
