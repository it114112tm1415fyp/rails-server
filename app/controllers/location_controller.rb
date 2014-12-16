class LocationController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	before_action(:check_customer_login)
	def get_list
		store_address = StoreAddress.all.collect { |x| {id: x.id, address: x.address} }
		shop_address = ShopAddress.all.collect { |x| {id: x.id, address: x.address} }
		car = Car.all.collect{ |x| {id: x.id, vehicle_registration_mark: x.vehicle_registration_mark} }
		json_response_success({Car: car, ShopAddress: shop_address, StoreAddress: store_address})
	end
end
