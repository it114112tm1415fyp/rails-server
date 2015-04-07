class RegionController < MobileApplicationController
	def get_list
		response_success(list: Region.all)
	end
end
