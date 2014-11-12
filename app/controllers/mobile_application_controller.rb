class MobileApplicationController < ApplicationController
	attr_accessor(:json_response)
	rescue_from(Exception) do |exception|
		raise if @_request.get?
		json_response_error('unknown', exception: exception.class.to_s, message: exception.message)
	end
	rescue_from(Error) { |x| json_response_error(x.error, x.detail) }
	rescue_from(ActionView::MissingTemplate) { json_response_success }
	before_action :verify_session
	after_action :put_verifier
	private
	def initialize
		@json_response = {}
	end
	def verify_session
		session.destroy if session.loaded? && session[:remote_addr] != @_request.remote_addr
	end
	def put_verifier
		session[:remote_addr] = @_request.remote_addr
	end
	def json_response_success(hash={})
		render(json: ActiveSupport::JSON.encode(@json_response.update(hash.update({success: true}))))
	end
	def json_response_error(error, hash={})
		render(json: ActiveSupport::JSON.encode(hash.update({success: false, error: error})))
	end
end