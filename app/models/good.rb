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
	@receive = CheckAction.find_by_name('receive')
	@issue = CheckAction.find_by_name('issue')
	@action_before = {}
	@action_before[@inspect] = [@inspect, @warehouse]
	@action_before[@warehouse] = [@unload, @leave]
	@action_before[@leave] = [@inspect, @warehouse, @receive]
	@action_before[@load] = [@leave, @unload, @receive]
	@action_before[@unload] = [@load]
	@action_before[@issue] = [@inspect, @warehouse, @unload]
	def qr_code
		'it114112tm1415fyp.good' + ActiveSupport::JSON.encode({good_id: id, order_id: order.id, departure: order.departure.display_name, destination: order.destination.display_name, rfid_tag: rfid_tag, weight: weight, fragile: fragile, flammable: flammable, order_time: created_at})
	end

	class << self
		def get_qr_code(id)
			Good.find(id).qr_code
		end
		def get_display_details(id)
			good = find(id)
			{location: good.location.display_name, rfid_tag: good.rfid_tag, weight: good.weight, fragile: good.fragile, flammable: good.flammable, last_action: good.last_action.name, last_action_time: good.updated_at, actions_log: good.check_logs.collect { |x| {time: x.time, location: x.location.display_name, action: x.check_action.name} }}
		end
		def get_basic_details(rfid)
			good = find_by_rfid_tag(rfid)
			order = good.order
			{id: good.id, order: order.id, weight: good.weight, fragile: good.fragile, flammable: good.flammable, departure: order.departure.display_name, destination: order.destination.display_name, store: order.destination.region.store_id, order_time: order.created_at}
		end
		def get_list
			{list: all.collect { |x| {good_id: x.id, order_id: x.order.id, location: x.location.display_name, location_type: x.location_type, last_action: x.last_action.name, departure: x.order.departure.display_name, destination: x.order.destination.display_name, rfid_tag: x.rfid_tag, weight: x.weight, fragile: x.fragile, flammable: x.flammable, order_time: x.created_at} }}
		end
		def inspect(good_id, store_id, staff)
			store = Store.find(store_id)
			log(good_id, store, staff, @inspect)
		end
		def warehouse(good_id, location_id, location_type, staff)
			raise(ParameterError, 'location_type') unless [Shop.to_s, Store.to_s].include?(location_type)
			location = const_get(location_type).find(location_id)
			log(good_id, location, staff, @warehouse)
		end
		def leave(good_id, location_id, location_type, staff)
			raise(ParameterError, 'location_type') unless [Shop.to_s, Store.to_s].include?(location_type)
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
				error("action '#{check_action.name}' can not be done after '#{good.last_action.name}'") unless @action_before[check_action].include?(good.last_action)
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
