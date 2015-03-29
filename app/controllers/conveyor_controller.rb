class ConveyorController < MobileApplicationController
	include(StaffMobileApplicationModule)
	before_action(:check_staff_login)
	before_action(:check_conveyor, except: :get_list)
	before_action(:check_control, only: :send_message)
	def get_control
		json_response_success(message: @conveyor.get_control(@staff, @_request.get?))
	end
	def get_list
		json_response_success(list: Conveyor.get_list)
	end
	def send_message
		params_require(:message)
		json_response_success(message: @conveyor.send_message(params[:message], @_request.get?))
	end
	private
	def check_control
		ConveyorControlling.check(@conveyor.id, @staff.id)
	end
	def check_conveyor
		params_require(:conveyor_id)
		@conveyor = Conveyor.find(params[:conveyor_id])
	end
end
