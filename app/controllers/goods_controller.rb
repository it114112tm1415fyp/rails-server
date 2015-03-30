class GoodsController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	include(StaffMobileApplicationModule)
	before_action(:check_customer_login, only: :get_details)
	before_action(:check_staff_login, except: :get_details)
	def add
		params_require(:goods_id, :order_id, :weight, :fragile, :flammable, :goods_photo)
		json_response_success(Goods.add(params[:goods_id], params[:order_id], params[:weight], params[:fragile], params[:flammable], params[:goods_photo], @staff))
	end
	def edit
		params_require(:goods_id)
		Goods.edit(params[:goods_id], params[:weight], params[:fragile], params[:flammable], params[:goods_photo], @staff)
	end
	def generate_temporary_qr_codes
		params_require(:number)
		number = params[:number].to_i
		raise(ParameterError, 'number') unless (1..1000).include?(number)
		json_response_success({goods_ids: Goods.generate_temporary_qr_codes(number)})
	end
	def get_details
		params_require(:goods_id)
		json_response_success(Goods.get_display_details(params[:goods_id]))
	end
	def get_list
		json_response_success(Goods.get_list)
	end
	def get_qr_code
		params_require(:goods_id)
		json_response_success(qr_code: Goods.get_qr_code(params[:goods_id]))
	end
	def inspect
		params_require(:goods_id, :store_id)
		json_response_success(Goods.inspect(params[:goods_id], params[:store_id], @staff))
	end
	def leave
		params_require(:goods_id, :location_id, :location_type)
		json_response_success(Goods.leave(params[:goods_id], params[:location_id], params[:location_type], @staff))
	end
	def load
		params_require(:goods_id, :car_id)
		json_response_success(Goods.load(params[:goods_id], params[:car_id], @staff))
	end
	def remove
		params_require(:goods_id, :order_id)
		Goods.remove(params[:string_id], params[:goods_id])
	end
	def unload
		params_require(:goods_id, :car_id)
		json_response_success(Goods.unload(params[:goods_id], params[:car_id], @staff))
	end
	def warehouse
		params_require(:goods_id, :location_id, :location_type)
		json_response_success(Goods.warehouse(params[:goods_id], params[:location_id], params[:location_type], @staff))
	end
end
