class OrderController < MobileApplicationController
	include(StaffMobileApplicationModule)
	before_action(:check_staff_login)
	def make
		params_require(:sender_id, :receiver, :staff_id, :pay_from_receiver, :goods, :departure_id, :departure_type, :destination_id, :destination_type)
		json_response_success(Order.make(params[:sender_id], params[:receiver], @staff, params[:pay_from_receiver], params[:goods], params[:departure_id], params[:departure_type], params[:destination_id], params[:destination_type]))
	end
end
