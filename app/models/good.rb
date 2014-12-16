class Good < ActiveRecord::Base
	belongs_to(:last_action, class_name: 'CheckAction')
	belongs_to(:location, polymorphic: true)
	belongs_to(:order)
	has_many(:check_logs)
	@inspect = CheckAction.find_by_name('inspect')
	@warehouse = CheckAction.find_by_name('warehouse')
	@leave = CheckAction.find_by_name('leave')
	@load = CheckAction.find_by_name('load')
	@unload = CheckAction.find_by_name('unload')
	@issue = CheckAction.find_by_name('issue')
	@action_before = {}
	@action_before[@inspect] = [@inspect, @warehouse]
	@action_before[@warehouse] = [@unload, @leave]
	@action_before[@leave] = [@inspect, @warehouse]
	@action_before[@load] = [@leave, @unload]
	@action_before[@unload] = [@load]
	@action_before[@issue] = [@inspect, @warehouse, @unload]

	class << self
		def get_list
			all.collect { |x| {good_id: x.id, order_id: x.order.id, location: x.location.display_name, location_type: x.location_type, last_action: x.last_action.name, departure: x.order.departure.display_name, destination: x.order.destination.display_name, rfid_tag: x.rfid_tag, weight: x.weight, fragile: x.fragile, flammable: x.flammable, order_time: x.created_at} }
		end
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
			result = {}
			transaction do
				good = Good.find(good_id)
				#@action_before[check_action].include?(good.last_action)
				CheckLog.create!(good: good, location: location, check_action: check_action, staff: staff)
				result[:update_time] = good.updated_at
				good.location = location
				good.last_action = check_action
				good.save!
				result
			end
		end
	end

end
