class CustomerAccountController < ApplicationController

	def login
		return unless check_parameters(:username, :password)
		json_response(CustomerAccount.login(params[:username], params[:password]))
	rescue
		json_response_error('unknown', error: $!.message)
	end

	def register
		return unless check_parameters(:username, :password, :name, :email, :phone, :address)
		json_response(CustomerAccount.register(params[:username], params[:password], params[:name], params[:email], params[:phone], params[:address]))
	rescue
		json_response_error('unknown', error: $!.message)
	end

end
