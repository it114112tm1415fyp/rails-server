class RegionController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	def get_list
		json_response_success(list: Region.get_list)
	end
end
