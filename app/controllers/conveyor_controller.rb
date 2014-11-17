class ConveyorController < StaffMobileApplicationController
	#before_action(:check_conveyor, except: get_list)
	def get_control
		Conveyor.get_control(@conveyor, session[:user_id])
		json_response_success(message: Conveyor.send_message(@conveyor, ''))
	end
	def get_list
		json_response_success(list: Conveyor.get_list)
	end
	def send_message
		params_require(:message)
		json_response_success(message: { ch: Array.new(4) { rand(6) }, cr: Array.new(2) { rand(3) }, mr: rand(3), st: Array.new(8) { rand(2) } })
	end
#	def send_message
#		params_require(:message)
#		json_response_success(message: Conveyor.send_message(@conveyor, params[:message]))
#	end
	private
	def check_conveyor
		params_require(:conveyor_name)
		@conveyor = Conveyor.find_by_name(params[:conveyor_name])
		error('conveyor not exist') unless @conveyor
	end
end
