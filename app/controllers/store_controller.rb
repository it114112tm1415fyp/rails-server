class StoreController < WebApplicationController
	def get_goods_qr_code
		goods = Goods.find_by_string_id(params[:goods_id])
		p goods.qr_code.size
		@qr = RQRCode::QRCode.new('123', size: 4, level: :h) if goods
	end
end
