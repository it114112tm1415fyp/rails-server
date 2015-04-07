class PictureController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	before_action(:check_customer_login, only: :goods)
	def goods
		params_require(:goods_id)
		response_success(goods_photo: Goods.find_by_string_id!(params[:goods_id]).goods_photo)
	end
	def sign
		params_require(:order_id, :role)
		order = Order.find(params[:order_id])
		case params[:role]
			when 'sender'
				image = order.sender_sign
			when 'receiver'
				image = order.receiver_sign
			else
				raise(ParameterError, 'role')
		end
		response_success(sign_image: image)
	end
end
