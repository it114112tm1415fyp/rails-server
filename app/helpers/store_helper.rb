module StoreHelper
	# @param [String] content
	# @param [Integer] size
	# @param [Integer] max
	# @return [RQRCode::QRCode]
	def render_qr_code(content, size=12, max=40)
		size = size
		begin
			RQRCode::QRCode.new(content, size: size)
		rescue RQRCode::QRCodeRunTimeError
			size += 1
			retry if size < max
		end
	end
end
