class Goods < ActiveRecord::Base
	self.table_name = 'goods'
	belongs_to(:last_action, class_name: CheckAction.name)
	belongs_to(:location, polymorphic: true)
	belongs_to(:order)
	belongs_to(:staff)
	has_many(:check_logs)
	validate(:shelf_id_is_less_than_shelf_number_of_store, if: :location_type_is_store )
	validates_absence_of(:shelf_id, unless: :location_type_is_store)
	validates_numericality_of(:shelf_id, greater_than_or_equal_to: 0, if: :location_type_is_store )
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, {except: [:id, :location_id, :location_type, :last_action_id, :staff_id, :goods_photo], include: [:location, :last_action, :staff, :check_logs], rename: {string_id: :id}}))
	end
	# @return [String]
	def qr_code
		'it114112tm1415fyp.goods' + ActiveSupport::JSON.encode({goods_id: string_id, order_id: order.id, departure: order.departure.long_name, destination: order.destination.long_name, rfid_tag: rfid_tag, weight: weight, fragile: fragile, flammable: flammable, order_time: created_at})
	end
	private
	# @return [FalseClass, TrueClass]
	def location_type_is_store
		location_type == Store.to_s
	end
	# @return [Meaningless]
	def shelf_id_is_less_than_shelf_number_of_store
		errors.add(:shelf_id, 'shelf_id is bigger than or equal to send_receive_number') if shelf_id > location.shelf_number
	end

	class << self
		# @param [String] goods_id
		# @param [Integer] order_id
		# @param [Numeric] weight
		# @param [FalseClass, TrueClass] flammable
		# @param [String] picture
		# @param [Staff] staff
		# @return [self]
		def add(goods_id, order_id, weight, fragile, flammable, picture, staff)
			order = Order.find(order_id)
			error('cannot edit order information after confirm') unless order.can_edit
			error('goods_id used') if find_by_string_id(goods_id)
			goods = create!(order: order, string_id: goods_id, location: order.departure, staff: staff, last_action: CheckAction.receive, weight: weight, fragile: fragile, flammable: flammable, goods_photo: picture)
			CheckLog.create!(goods: goods, location: goods.location, check_action: CheckAction.receive, staff: staff)
			goods
		end
		# @param [String] goods_id
		# @param [Numeric] weight
		# @param [FalseClass, TrueClass] flammable
		# @param [String] picture
		# @param [Staff] staff
		# @return [self]
		def edit(goods_id, weight, fragile, flammable, picture, staff)
			goods = find_by_string_id!(goods_id)
			error('cannot edit order information after confirm') unless goods.order.can_edit
			goods.string_id = goods_id if goods_id
			goods.staff = staff
			goods.weight = weight if weight
			goods.fragile = fragile if fragile
			goods.flammable = flammable if flammable
			goods.picture = picture if picture
			goods.save!
			goods
		end
		# @param [Random] random_seed
		# @return [String]
		def generate_temporary_qr_code(random_seed=Random.new)
			begin
				goods_id = random_seed.rand(2176782336).to_s(36).rjust(6, '0')
			end while find_by_string_id(goods_id)
			'it114112tm1415fyp.temporary_goods_tag' + ActiveSupport::JSON.encode({goods_id: goods_id})
		end
		# @param [Integer] number
		# @return [Array<String>]
		def generate_temporary_qr_codes(number)
			random_seed = Random.new
			Array.new(number) { generate_temporary_qr_code(random_seed) }
		end
		# @param [String] goods_id
		# @param [Integer] store_id
		# @param [Staff] staff
		# @return [Meaningless]
		def inspect(goods_id, store_id, staff)
			store = Store.find(store_id)
			log(goods_id, store, staff, CheckAction.inspect)
		end
		# @param [String] goods_id
		# @param [Integer] location_id
		# @param [String] location_type
		# @param [Staff] staff
		# @return [Meaningless]
		def leave(goods_id, location_id, location_type, staff)
			raise(ParameterError, 'location_type') unless [Shop.to_s, Store.to_s].include?(location_type)
			location = const_get(location_type).find(location_id)
			log(goods_id, location, staff, CheckAction.leave)
		end
		# @param [String] goods_id
		# @param [Integer] car_id
		# @param [Staff] staff
		# @return [Meaningless]
		def load(goods_id, car_id, staff)
			car = Car.find(car_id)
			log(goods_id, car, staff, CheckAction.load)
		end
		# @param [String] goods_id
		# @param [Integer] order_id
		# @return [Meaningless]
		def remove(goods_id, order_id)
			order = Order.find(order_id)
			error('cannot edit order information after confirm') unless order.can_edit
			goods = find_by_string_id(goods_id)
			error('goods not exist in this order') unless goods && goods.order == order
			goods.destroy
		end
		# @param [String] goods_id
		# @param [Integer] car_id
		# @param [Staff] staff
		# @return [Meaningless]
		def unload(goods_id, car_id, staff)
			car = Car.find(car_id)
			log(goods_id, car, staff, CheckAction.unload)
		end
		# @param [String] goods_id
		# @param [Integer] location_id
		# @param [String] location_type
		# @param [Staff] staff
		# @return [Meaningless]
		def warehouse(goods_id, location_id, location_type, staff)
			raise(ParameterError, 'location_type') unless [Shop.to_s, Store.to_s].include?(location_type)
			location = const_get(location_type).find(location_id)
			log(goods_id, location, staff, CheckAction.warehouse)
		end
		private
		# @param [String] goods_id
		# @param [Car, Shop, SpecifyAddress, Store] location
		# @param [Staff] staff
		# @param [CheckAction] check_action
		# @return [Meaningless]
		def log(goods_id, location, staff, check_action)
			transaction do
				goods = find_by_string_id(goods_id)
				error("action '#{check_action.name}' can not be done after '#{goods.last_action.name}'") unless check_action.can_done_after(goods.last_action)
				CheckLog.create!(goods: goods, location: location, check_action: check_action, staff: staff)
				goods.location = location
				goods.last_action = check_action
				goods.save!
			end
		end
	end

end
