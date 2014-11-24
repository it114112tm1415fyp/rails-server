class AdminController < WebApplicationController
	before_action(:check_login, except: [:login, :logout])
	def login
		@error_message = params[:error_message]
		@warning_message = params[:warning_message]
		@info_message = params[:info_message]
		if params_exist(:username, :password)
			error('username not exist') if params[:username] != $admin_username
			Staff.admin_login(params[:password])
			session[:login] = true
			redirect_to(action: :edit_profile)
		end
	rescue Error
		redirect_to(action: :login, error_message: [$!.message])
	end
	def logout
		session.destroy
		redirect_to(action: :login)
	end
	def edit_profile
		render(json: nil)
	end
	private
	def check_login
		return redirect_to(action: :login, warning_message: ['connection expired']) if @expired
		redirect_to(action: :login, warning_message: ['need login']) unless session[:login]
	end
end
