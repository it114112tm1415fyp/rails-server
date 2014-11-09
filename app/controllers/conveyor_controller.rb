class ConveyorController < ApplicationController

	def send_message
		return unless check_parameters(:conveyor_name, :message)
		json_response(ConveyorHelper.send_message(params[:conveyor_name], params[:message]))
	rescue
		json_response_error('unknown', error: $!.message)
	end

	def get_list
		json_response(ConveyorHelper.get_list)
	rescue
		json_response_error('unknown', error: $!.message)
	end

end
