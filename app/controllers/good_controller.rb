class GoodController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	include(StaffMobileApplicationModule)
	before_action(:check_customer_login, only: :get_details)
	before_action(:check_staff_login, except: :get_details)
	def add
		params_require(:good_id, :order_id, :weight, :fragile, :flammable, :goods_photo)
		json_response_success(Good.add(params[:good_id], params[:order_id], params[:weight], params[:fragile], params[:flammable], params[:goods_photo], @staff))
	end
	def edit
		params_require(:good_id)
		Good.edit(params[:good_id], params[:weight], params[:fragile], params[:flammable], params[:goods_photo], @staff)
	end
	def generate_temporary_qr_codes
		params_require(:number)
		number = params[:number].to_i
		raise(ParameterError, 'number') unless (1..1000).include?(number)
		json_response_success({good_ids: Good.generate_temporary_qr_codes(number)})
	end
	def get_details
		params_require(:good_id)
		json_response_success(Good.get_display_details(params[:good_id]))
	end
	def get_list
		json_response_success(Good.get_list)
	end
	def get_qr_code
		params_require(:good_id)
		json_response_success(qr_code: Good.get_qr_code(params[:good_id]))
	end
	def inspect
		params_require(:good_id, :store_id)
		json_response_success(Good.inspect(params[:good_id], params[:store_id], @staff))
	end
	def leave
		params_require(:good_id, :location_id, :location_type)
		json_response_success(Good.leave(params[:good_id], params[:location_id], params[:location_type], @staff))
	end
	def load
		params_require(:good_id, :car_id)
		json_response_success(Good.load(params[:good_id], params[:car_id], @staff))
	end
	def remove
		params_require(:good_id, :order_id)
		Good.remove(params[:string_id], params[:good_id])
	end
	def unload
		params_require(:good_id, :car_id)
		json_response_success(Good.unload(params[:good_id], params[:car_id], @staff))
	end
	def warehouse
		params_require(:good_id, :location_id, :location_type)
		json_response_success(Good.warehouse(params[:good_id], params[:location_id], params[:location_type], @staff))
	end
end
