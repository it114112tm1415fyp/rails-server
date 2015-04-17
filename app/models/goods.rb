class Goods < ActiveRecord::Base
	self.table_name = 'goods'
	belongs_to(:last_action, class_name: CheckAction)
	belongs_to(:location, polymorphic: true)
	belongs_to(:next_stop, polymorphic: true)
	belongs_to(:order)
	belongs_to(:staff)
	has_many(:goods_inspect_task_ships, dependent: :destroy)
	has_many(:goods_visit_task_order_ships, dependent: :destroy)
	has_many(:goods_transfer_task_ships, dependent: :destroy)
	validate(:shelf_id_is_less_than_shelf_number_of_store, if: :last_action_is_warehouse )
	validates_numericality_of(:shelf_id, greater_than_or_equal_to: 0, if: :last_action_is_warehouse )
	before_validation do
		self.last_action ||= CheckAction.receive
		self.location ||= order.departure
		self.next_stop = order.departure.region.store if location == order.departure
	end
	scope(:non_sent, Proc.new { joins(:order).where("`#{table_name}`.`#{:location_id}` != `#{Order.table_name}`.`#{:destination_id}` OR `#{table_name}`.`#{:location_type}` != `#{Order.table_name}`.`#{:destination_type}`") })
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, except: [:id, :location_id, :next_stop_id, :next_stop_type, :location_type, :last_action_id, :staff_id, :goods_photo], include: [:location, :last_action, :staff], method: :check_logs, rename: {string_id: :id}))
	end
	# @return [ActiveRecord::Relative]
	def check_logs
		(goods_inspect_task_ships.collect_concat(&:check_logs) + goods_visit_task_order_ships.collect_concat(&:check_logs) + goods_transfer_task_ships.collect_concat(&:check_logs)).sort_by(&:time)
	end
	# @return [ActiveRecord::Relative]
	def departure
		order.departure
	end
	# @return [ActiveRecord::Relative]
	def destination
		order.destination
	end
	# @return [String]
	def qr_code
		'it114112tm1415fyp.goods' + ActiveSupport::JSON.encode({goods_id: string_id, order_id: order.id, departure: order.departure.long_name, destination: order.destination.long_name, rfid_tag: rfid_tag, weight: weight, fragile: fragile, flammable: flammable, order_time: created_at})
	end
	# @return [Meaningless]
	def update_next_stop
		self.next_stop = GoodsRouter.new(self).next_stop
	end
	private
	# @return [FalseClass, TrueClass]
	def last_action_is_warehouse
		last_action == CheckAction.warehouse
	end
	# @return [Meaningless]
	def shelf_id_is_less_than_shelf_number_of_store
		errors.add(:shelf_id, 'shelf_id is bigger than or equal to shelf_number of store') if shelf_id > location.shelf_number
	end

	class << self
		# @param [String] goods_id
		# @param [Integer] order_id
		# @param [Numeric] weight
		# @param [FalseClass, TrueClass] flammable
		# @param [String] picture
		# @param [Staff] staff
		# @return [self]
		def add(task_id, goods_id, order_id, weight, fragile, flammable, picture, staff)
			task_worker = TaskWorker.find(task_id)
			raise(ParameterError 'task_id') unless [ReceiveTask.name, ServeTask.name].include?(task_worker.task_type)
			order = Order.find(order_id)
			error('cannot edit order information after confirm') unless order.can_edit
			error('goods_id used') if find_by_string_id(goods_id)
			goods = create!(order: order, string_id: goods_id, staff: staff, weight: weight, fragile: fragile, flammable: flammable, goods_photo: picture)
			if task_worker.task_type == ReceiveTask
				receive_task_order = VisitTaskOrder.find_by!(order: order, visit_task_id: task_worker.task_id)
				task_goods = GoodsVisitTaskOrderShip.new(goods: goods, visit_task_order: receive_task_order)
			else
				task_goods = GoodsServeTaskShip.new(goods: goods, serve_task_id: task_worker.task_id)
			end
			CheckLog.create!(task_worker: task_worker, task_goods: task_goods)
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
		def generate_goods_id(random_seed=Random.new)
			begin
				goods_id = random_seed.rand(2176782336).to_s(36).rjust(6, '0')
			end while find_by_string_id(goods_id)
			goods_id
		end
		# @param [Random] random_seed
		# @return [String]
		def generate_temporary_qr_code(random_seed=Random.new)
			'it114112tm1415fyp.temporary_goods_tag' + ActiveSupport::JSON.encode({goods_id: generate_goods_id(random_seed)})
		end
		# @param [Integer] number
		# @return [Array<String>]
		def generate_temporary_qr_codes(number)
			random_seed = Random.new
			Array.new(number) { generate_temporary_qr_code(random_seed) }
		end
		# @param [Integer] task_id
		# @param [String] goods_id
		# @param [Integer] store_id
		# @param [Staff] staff
		# @return [Meaningless]
		def inspect(task_id, goods_id, store_id, staff)
			log(task_id, goods_id, store_id, Store, staff, CheckAction.inspect)
		end
		# @param [Integer] task_id
		# @param [String] goods_id
		# @param [Integer] location_id
		# @param [String] location_type
		# @param [Staff] staff
		# @return [Meaningless]
		def leave(task_id, goods_id, location_id, location_type, staff)
			raise(ParameterError, 'location_type') unless [Shop.name, Store.name].include?(location_type)
			log(task_id, goods_id, location_id, location_type, staff, CheckAction.leave)
		end
		# @param [Integer] task_id
		# @param [String] goods_id
		# @param [Integer] car_id
		# @param [Staff] staff
		# @return [Meaningless]
		def load(task_id, goods_id, car_id, staff)
			log(task_id, goods_id, car_id, Car, staff, CheckAction.load)
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
		# @param [Integer] task_id
		# @param [String] goods_id
		# @param [Integer] car_id
		# @param [Staff] staff
		# @return [Meaningless]
		def unload(task_id, goods_id, car_id, staff)
			log(task_id, goods_id, car_id, Car, staff, CheckAction.unload)
		end
		# @param [Integer] task_id
		# @param [String] goods_id
		# @param [Integer] location_id
		# @param [String] location_type
		# @param [Staff] staff
		# @return [Meaningless]
		def warehouse(task_id, goods_id, location_id, location_type, staff)
			raise(ParameterError, 'location_type') unless [Shop.name, Store.name].include?(location_type)
			log(task_id, goods_id, location_id, location_type, staff, CheckAction.warehouse)
		end
		private
		# @param [Integer] task_id
		# @param [String] goods_id
		# @param [Integer] location_id
		# @param [String] location_type
		# @param [Staff] staff
		# @param [CheckAction] check_action
		# @return [Meaningless]
		def log(task_id, goods_id, location_id, location_type, staff, check_action)
			transaction do
				goods = find_by_string_id(goods_id)
				error("action '#{check_action.name}' can not be done after '#{goods.last_action.name}'") unless check_action.can_done_after(goods.last_action)
				task = TaskWorker.find(task_id).task
				task_goods = task.class::TASK_OBJECT_CLASS.find_by!(goods: goods, task.class::TASK_OBJECT_CLASS.task => task)
				CheckLog.create!(task_goods: task_goods, location_id: location_id, location_type: location_type, check_action: check_action, staff: staff)
				goods.location_id = location_id
				goods.location_type = location_type
				goods.last_action = check_action
				goods.save!
			end
		end
	end

end
