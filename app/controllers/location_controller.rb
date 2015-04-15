class LocationController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	include(StaffMobileApplicationModule)
	before_action(:check_customer_login)
	def get_list
		response_success({cars: Car.enabled, shops: Shop.enabled, stores: Store.enabled})
	end
	def get_specify_address_id
		params_require(:address, :region_id)
		response_success({id: SpecifyAddress.find_or_create_by!(address: params[:address], region_id: params[:region_id]).id})
	end
end
