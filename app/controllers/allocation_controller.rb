class AllocationController < DotNetApplicationController
	def get_good_details
		params_require(:rfid)
		json_response_success(Good.get_basic_details(params[:rfid]))
	end
end
