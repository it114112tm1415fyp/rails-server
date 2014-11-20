class MobileApplicationController < ApplicationController
	attr_accessor(:json_response)
	rescue_from(Exception) do |exception|
		raise if @_request.get?
		json_response_error('unknown', exception: exception.class.to_s, message: exception.message)
	end
	rescue_from(Error) { |x| json_response_error(x.error, x.detail) }
	rescue_from(ActionView::MissingTemplate) { json_response_success }
	def edit_session
		only_available_at_development
		params_require(:key, :value)
		session[params[:key]] = params[:value]
		@json_response[:session] = {}
		session.keys.each { |x| @json_response[:session][x] = session[x] }
	end
	def destroy_session
		only_available_at_development
		session.destroy
	end
	def view_session
		only_available_at_development
		@json_response[:session] = {}
		session.keys.each { |x| @json_response[:session][x] = session[x] }
	end
	private
	def initialize
		@json_response = {}
	end
	def json_response_success(hash={})
		response = @json_response.update(hash.update({ success: true }))
		render(json: response)
		puts(response)
	end
	def json_response_error(error, hash={})
		response = hash.update({ success: false, error: error })
		render(json: response)
		puts(response)
	end
	def only_available_at_development
		raise(NotInDevelopmentModeError) unless ENV['rails_env'] == 'development'
	end
end
