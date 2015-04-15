class AllocationController < DotNetApplicationController
	def get_goods_details
		params_require(:rfid)
		response_simple_success(Goods.find_by_rfid_tag!(params[:rfid]))
	end
end
