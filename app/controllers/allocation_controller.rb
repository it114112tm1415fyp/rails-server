class AllocationController < DotNetApplicationController
	def get_goods_details
		params_require(:rfid)
		json_response_success(Goods.get_basic_details(params[:rfid]))
	end
end
