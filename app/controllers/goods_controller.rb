class GoodsController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	include(StaffMobileApplicationModule)
	before_action(:check_customer_login, only: :get_details)
	before_action(:check_staff_login, except: :get_details)
	def add
		params_require(:task_id, :goods_id, :order_id, :weight, :fragile, :flammable, :goods_photo)
		response_success(Goods.add(params[:task_id], params[:goods_id], params[:order_id], params[:weight], params[:fragile], params[:flammable], params[:goods_photo], @staff))
	end
	def edit
		params_require(:goods_id)
		response_success(Goods.edit(params[:goods_id], params[:weight], params[:fragile], params[:flammable], params[:goods_photo], @staff))
	end
	def generate_temporary_qr_codes
		params_require(:number)
		number = params[:number].to_i
		raise(ParameterError, 'number') unless (1..1000).include?(number)
		response_success({goods_ids: Goods.generate_temporary_qr_codes(number)})
	end
	def get_details
		params_require(:goods_id)
		response_success(Goods.find_by_string_id!(params[:goods_id]))
	end
	def get_list
		response_success(Goods.all)
	end
	def get_qr_code
		params_require(:goods_id)
		response_success(qr_code: Goods.find_by_string_id!(params[:goods_id]).qr_code)
	end
	def remove
		params_require(:goods_id, :order_id)
		Goods.remove(params[:string_id], params[:goods_id])
	end
end
