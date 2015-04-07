class AllocationController < DotNetApplicationController
	def get_goods_details
		params_require(:rfid)
		response_success(Goods.find_by_rfid_tag!(params[:rfid]))
		# response_success(Goods.get_basic_details(params[:rfid]))
	end
end
