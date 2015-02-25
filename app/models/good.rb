class Good < ActiveRecord::Base
	belongs_to(:last_action, class_name: CheckAction.to_s)
	belongs_to(:location, polymorphic: true)
	belongs_to(:order)
	belongs_to(:staff)
	has_many(:check_logs)
	def qr_code
		'it114112tm1415fyp.good' + ActiveSupport::JSON.encode({good_id: id, order_id: order.id, departure: order.departure.long_name, destination: order.destination.long_name, rfid_tag: rfid_tag, weight: weight, fragile: fragile, flammable: flammable, order_time: created_at})
	end

	class << self
		def add(string_id, order_id, weight, fragile, flammable, picture, staff)
			order = Order.find(order_id)
			error('cannot edit order information after confirm') unless order.can_edit
			error('string_id used') if find_by_string_id(string_id)
			good = create!(order: order, string_id: string_id, location: order.departure, staff: staff, last_action: CheckAction.receive, weight: weight, fragile: fragile, flammable: flammable, picture: picture)
			CheckLog.create!(good: good, location: good.location, check_action: CheckAction.receive, staff: staff)
			{id: good.id}
		end
		def edit(good_id, string_id, weight, fragile, flammable, picture, staff)
			good = find(good_id)
			error('cannot edit order information after confirm') unless good.order.can_edit
			error('string_id used') if string_id && good.string_id != string_id && find_by_string_id(string_id)
			good.string_id = string_id if string_id
			good.staff = staff
			good.weight = weight if weight
			good.fragile = fragile if fragile
			good.flammable = flammable if flammable
			good.picture = picture if picture
			good.save!
		end
		def generate_string_id(number)
			string_ids = []
			random_seed = Random.new
			while string_ids.size < number
				string_id = random_seed.rand(2176782336).to_s(36).rjust(6, '0')
				string_ids << string_id unless find_by_string_id(string_id)
			end
			{string_ids: string_ids}
		end
		def get_qr_code(good_id)
			find(good_id).qr_code
		end
		def get_display_details(good_id)
			good = find(good_id)
			{location: good.location.long_name, rfid_tag: good.rfid_tag, weight: good.weight, fragile: good.fragile, flammable: good.flammable, last_action: good.last_action.name, last_action_time: good.updated_at, actions_log: good.check_logs.collect { |x| {time: x.time, location: x.location.long_name, action: x.check_action.name} }}
		end
		def get_basic_details(rfid)
			good = find_by_rfid_tag(rfid)
			error('non registered goods') unless good
			order = good.order
			{id: good.id, order: order.id, weight: good.weight, fragile: good.fragile, flammable: good.flammable, departure: order.departure.long_name, destination: order.destination.long_name, store: order.destination.region.store_id, order_time: order.created_at}
		end
		def get_list
			{list: all.collect { |x| {good_id: x.id, order_id: x.order.id, location: x.location.long_name, location_type: x.location_type, last_action: x.last_action.name, departure: x.order.departure.long_name, destination: x.order.destination.long_name, rfid_tag: x.rfid_tag, weight: x.weight, fragile: x.fragile, flammable: x.flammable, order_time: x.created_at} }}
		end
		def inspect(good_id, store_id, staff)
			store = Store.find(store_id)
			log(good_id, store, staff, CheckAction.inspect)
		end
		def warehouse(good_id, location_id, location_type, staff)
			raise(ParameterError, 'location_type') unless [Shop.to_s, Store.to_s].include?(location_type)
			location = const_get(location_type).find(location_id)
			log(good_id, location, staff, CheckAction.warehouse)
		end
		def leave(good_id, location_id, location_type, staff)
			raise(ParameterError, 'location_type') unless [Shop.to_s, Store.to_s].include?(location_type)
			location = const_get(location_type).find(location_id)
			log(good_id, location, staff, CheckAction.leave)
		end
		def load(string_id, car_id, staff)
			car = Car.find(car_id)
			log(good_id, car, staff, CheckAction.load)
		end
		def remove(string_id, order_id)
			order = Order.find(order_id)
			error('cannot edit order information after confirm') unless order.can_edit
			good = find_by_string_id(string_id)
			error('good not exist in this order') unless good && good.order == order
			good.destroy
		end
		def unload(good_id, car_id, staff)
			car = Car.find(car_id)
			log(good_id, car, staff, CheckAction.unload)
		end
		private
		def log(good_id, location, staff, check_action)
			result = {}
			transaction do
				good = find(good_id)
				error("action '#{check_action.name}' can not be done after '#{good.last_action.name}'") unless check_action.can_done_after(good.last_action)
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
