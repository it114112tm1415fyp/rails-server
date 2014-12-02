class AdminController < WebApplicationController
	before_action(:check_login, except: [:login, :logout])
	def login
		@error_message = params[:error_message]
		@warning_message = params[:warning_message]
		@info_message = params[:info_message]
		if params_exist(:username, :password)
			error('Username not exist') if params[:username] != $admin_username
			Staff.admin_login(params[:password])
			session[:login] = true
			redirect_to(action: :server_status)
		end
	rescue Error
		redirect_to(action: :login, error_message: [$!.message])
	end
	def logout
		session.destroy
		redirect_to(action: :login)
	end
	def server_status
	end
	private
	def check_login
		return redirect_to(action: :login, warning_message: ['Connection expired']) if @expired
		redirect_to(action: :login, warning_message: ['Please login first']) unless session[:login]
	end
end
