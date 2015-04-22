class StoreController < WebApplicationController
	def get_goods_qr_code
		@goods = Goods.find_by_string_id(params[:goods_id])
	end
end
