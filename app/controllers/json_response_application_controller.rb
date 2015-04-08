class JsonResponseApplicationController < ApplicationController
	@skip_printing_response = false
	attr_accessor(:json_response)
	rescue_from(Exception) do |exception|
		raise if @_request.get?
		response_error('unknown', exception: exception.class.name, message: exception.message)
	end
	rescue_from(Error) { |x| response_error(x.message, x.details) }
	rescue_from(ActionView::MissingTemplate) do
		_process_action_callbacks.find_all { |x| x.kind == :after && x.send(:conditions_lambdas).all? { |x| x.call(self, nil) } }.each do |x|
			case x.raw_filter
				when Class
					x.raw_filter.filter
				when Symbol
					method(x.raw_filter).call
				when Proc
					x.raw_filter.call
				else
					raise('Unknown filter type')
			end
		end
		response_success
	end
	private
	# @param [ActiveRecord::Base, Hash] contents
	# @return [Meaningless]
	def response_success(contents=nil)
		json_response({success: true, content: contents})
	end
	# @param [Exception] error
	# @param [Hash] contents
	# @return [Meaningless]
	def response_error(error, contents={})
		json_response(contents.update({success: false, error: error}))
	end
	# @param [Hash] response
	# @return [Meaningless]
	def json_response(response)
		render(json: response) unless @skip_printing_response
		logger.debug('Return json : ' + @_response_body[0])
	end

	class << self
		def skip_printing_response
			@skip_printing_response
		end
	end

end
