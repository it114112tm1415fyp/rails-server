class RegionController < MobileApplicationController
	def get_list
		response_success(list: Region.enabled)
	end
end
