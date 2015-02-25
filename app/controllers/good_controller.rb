class GoodController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	include(StaffMobileApplicationModule)
	before_action(:check_customer_login, only: :get_details)
	before_action(:check_staff_login, except: :get_details)
	def add
		params_require(:string_id, :order_id, :weight, :fragile, :flammable, :picture)
		json_response_success(Good.add(params[:string_id], params[:order_id], params[:weight], params[:fragile], params[:flammable], params[:picture], @staff))
	end
	def edit
		params_require(:good_id)
		Good.edit(params[:good_id], params[:string_id], params[:weight], params[:fragile], params[:flammable], params[:picture], @staff)
	end
	def generate_string_id
		params_require(:number)
		number = params[:number].to_i
		raise(ParameterError, 'number') unless (1..1000).include?(number)
		json_response_success(Good.generate_string_id(number))
	end
	def get_details
		params_require(:good_id)
		json_response_success(Good.get_display_details(params[:good_id]))
	end
	def get_list
		json_response_success(Good.get_list)
	end
	def get_qr_code
		params_require(:string_id)
		render(text: Good.get_qr_code(params[:string_id]))
	end
	def inspect
		params_require(:string_id, :store_id)
		json_response_success(Good.inspect(params[:string_id], params[:store_id], @staff))
	end
	def leave
		params_require(:string_id, :location_id, :location_type)
		json_response_success(Good.leave(params[:string_id], params[:location_id], params[:location_type], @staff))
	end
	def load
		params_require(:string_id, :car_id)
		json_response_success(Good.load(params[:string_id], params[:car_id], @staff))
	end
	def remove
		params_require(:string_id, :order_id)
		Good.remove(params[:string_id], params[:order_id])
	end
	def unload
		params_require(:string_id, :car_id)
		json_response_success(Good.unload(params[:string_id], params[:car_id], @staff))
	end
	def warehouse
		params_require(:string_id, :location_id, :location_type)
		json_response_success(Good.warehouse(params[:string_id], params[:location_id], params[:location_type], @staff))
	end
end
