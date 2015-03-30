class RegionController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	before_action(:check_customer_login)
	def get_list
		json_response_success(list: Region.get_list)
	end
end
