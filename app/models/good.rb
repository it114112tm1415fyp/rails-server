class Good < ActiveRecord::Base
	belongs_to(:order)
	belongs_to(:location, polymorphic: true)
	has_many(:check_logs)
	@inspect = CheckAction.find_by_name('inspect')
	@warehouse = CheckAction.find_by_name('warehouse')
	@leave = CheckAction.find_by_name('leave')
	@load = CheckAction.find_by_name('load')
	@unload = CheckAction.find_by_name('unload')
	@issue = CheckAction.find_by_name('issue')

	class << self
		def inspect(good_id, store_id, staff)
			store = StoreAddress.find(store_id)
			log(good_id, store, staff, @inspect)
		end
		def warehouse(good_id, location_id, location_type, staff)
			raise(ParameterError, 'location_type') unless ['ShopAddress', 'StoreAddress'].include?(location_type)
			location = const_get(location_type).find(location_id)
			log(good_id, location, staff, @warehouse)
		end
		def leave(good_id, location_id, location_type, staff)
			raise(ParameterError, 'location_type') unless ['ShopAddress', 'StoreAddress'].include?(location_type)
			location = const_get(location_type).find(location_id)
			log(good_id, location, staff, @leave)
		end
		def load(good_id, car_id, staff)
			car = Car.find(car_id)
			log(good_id, car, staff, @load)
		end
		def unload(good_id, car_id, staff)
			car = Car.find(car_id)
			log(good_id, car, staff, @unload)
		end
		private
		def log(good_id, location, staff, check_action)
			transaction do
				good = Good.find(good_id)
				CheckLog.create!(good: good, location: location, check_action: check_action, staff: staff)
				good.location = location
				good.save!
				good
			end
		end
	end

end
