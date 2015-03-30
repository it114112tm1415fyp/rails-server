class PictureController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	before_action(:check_customer_login, only: :goods)
	def goods
		params_require(:goods_id)
		json_response_success(goods_photo: Goods.find_by_string_id!(params[:goods_id]).goods_photo)
	end
end
