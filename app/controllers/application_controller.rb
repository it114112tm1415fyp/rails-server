class ApplicationController < ActionController::Base

	protect_from_forgery with: :exception

	def check_parameters(*parameters)
		for parameter in parameters
			return json_response_error('parameter not exist', parameter: parameter) unless params.has_key?(parameter)
		end
		true
	end

	def json_response(helper_response)
		case helper_response
			when ApplicationModel::Success
				json_response_success(helper_response.detail)
			when ApplicationModel::Error
				json_response_error(helper_response.error, helper_response.detail)
		end
	end

	def json_response_success(hash={})
		render(json: ActiveSupport::JSON.encode({success: true}.update(hash)))
		true
	end

	def json_response_error(error, hash={})
		render(json: ActiveSupport::JSON.encode({success: false, error: error}.update(hash)))
		false
	end

end
