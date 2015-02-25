class LocationController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	include(StaffMobileApplicationModule)
	before_action(:check_customer_login)
	def get_list
		store = Store.get_list
		shop = Shop.get_list
		car = Car.get_list
		json_response_success({cars: car, shops: shop, stores: store})
	end
	def get_specify_address_id
		params_require(:address, :region_id)
		address = SpecifyAddress.find_or_create_by!(address: params[:address], region_id: params[:region_id])
		json_response_success({id: address.id})
	end
end
