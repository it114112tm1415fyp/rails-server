class LocationController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	before_action(:check_customer_login)
	def get_list
		store = Store.get_list
		shop = Shop.get_list
		car = Car.get_list
		json_response_success({cars: car, shops: shop, stores: store})
	end
end
