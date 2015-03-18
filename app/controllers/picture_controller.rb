class PictureController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	before_action(:check_customer_login, only: :good)
	def good
		params_require(:good_id)
		json_response_success(goods_photo: Good.find_by_string_id!(params[:good_id]).goods_photo)
	end
end
