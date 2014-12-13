class OrderController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	include(StaffMobileApplicationModule)
	before_action(:check_staff_login, only: :make)
	def make
		params_require(:sender_id, :receiver, :staff_id, :pay_form_receiver, :goods, :location_id, :location_type)
		json_response_success(Order.make(params[:sender_id], params[:receiver], @staff, params[:pay_form_receiver], params[:goods], params[:location_id], params[:location_type]))
	end
end
