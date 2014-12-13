class OrderController < MobileApplicationController
	include(StaffMobileApplicationModule)
	before_action(:check_staff_login)
	def make
		params_require(:sender_id, :receiver, :staff_id, :pay_from_receiver, :goods, :location_id, :location_type)
		json_response_success(Order.make(params[:sender_id], params[:receiver], @staff, params[:pay_from_receiver], params[:goods], params[:location_id], params[:location_type]))
	end
end
