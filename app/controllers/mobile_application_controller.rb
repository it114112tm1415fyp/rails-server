class MobileApplicationController < ApplicationController
	attr_accessor(:json_response)
	rescue_from(Exception) do |exception|
		raise if @_request.get?
		json_response_error('unknown', exception: exception.class.to_s, message: exception.message)
	end
	rescue_from(Error) { |x| json_response_error(x.error, x.detail) }
	rescue_from(ActionView::MissingTemplate) { json_response_success }
	def view_session
		only_available_in_development_mode
		@json_response[:session] = {}
		session.keys.each { |x| @json_response[:session][x] = session[x] }
	end
	def destroy_session
		only_available_in_development_mode
		session.destroy
	end
	private
	def initialize
		@json_response = {}
	end
	def json_response_success(hash={})
		render(json: ActiveSupport::JSON.encode(@json_response.update(hash.update({ success: true }))))
	end
	def json_response_error(error, hash={})
		render(json: ActiveSupport::JSON.encode(hash.update({ success: false, error: error })))
	end
	def only_available_in_development_mode
		raise(NotInDevelopmentModeError) unless ENV['rails_env'] == 'development'
	end
end
