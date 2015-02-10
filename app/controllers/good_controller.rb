class GoodController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	include(StaffMobileApplicationModule)
	before_action(:check_customer_login, only: :get_good_detail)
	before_action(:check_staff_login, only: [:get_list, :inspect, :warehouse, :leave, :load, :unload])
	def get_qr_code
		params_require(:id)
		render(text: Good.get_qr_code(params[:id]))
	end
	def get_details
		params_require(:id)
		json_response_success(Good.get_display_details(params[:id]))
	end
	def get_list
		json_response_success(Good.get_list)
	end
	def inspect
		params_require(:good_id, :store_id)
		json_response_success(Good.inspect(params[:good_id], params[:store_id], @staff))
	end
	def warehouse
		params_require(:good_id, :location_id, :location_type)
		json_response_success(Good.warehouse(params[:good_id], params[:location_id], params[:location_type], @staff))
	end
	def leave
		params_require(:good_id, :location_id, :location_type)
		json_response_success(Good.leave(params[:good_id], params[:location_id], params[:location_type], @staff))
	end
	def load
		params_require(:good_id, :car_id)
		json_response_success(Good.load(params[:good_id], params[:car_id], @staff))
	end
	def unload
		params_require(:good_id, :car_id)
		json_response_success(Good.unload(params[:good_id], params[:car_id], @staff))
	end
end
