class JsonResponseApplicationController < ApplicationController
	attr_accessor(:json_response)
	rescue_from(Exception) do |exception|
		raise if @_request.get?
		json_response_error('unknown', exception: exception.class.to_s, message: exception.message)
	end
	rescue_from(Error) { |x| json_response_error(x.message, x.detail) }
	rescue_from(ActionView::MissingTemplate) do
		_process_action_callbacks.find_all { |x| x.kind == :after }.collect(&:raw_filter).each do |x|
			case x
				when Class
					x.filter
				when Symbol
					method(x).call
				when Proc
					x.call
				else
					raise('Unknown filter type')
			end
		end
		json_response_success
	end
	private
	def initialize
		@json_response = {}
	end
	def json_response_success(hash={})
		json_response(@json_response.update(hash.update({ success: true })))
	end
	def json_response_error(error, hash={})
		json_response(hash.update({ success: false, error: error }))
	end
	def json_response(response)
		render(json: response)
		logger.debug('Return json : ' + @_response_body[0])
	end
end
