class VisitTask < LogisticTask
	CRON_TASK_CONTENT = Proc.new do |x1|
		x1.orders.each { |x2| TASK_OBJECT_CLASS.create!(visit_task: x1, goods: x2) }
		x1.generated = true
		x1.save!
	end
	CRON_TASK_TAG = :visit_task_generate_goods_list
	# TASK_OBJECT_CLASS = VisitTaskOrder
	# TASK_OBJECT_TYPE = :order
	TASK_PLAN_CLASS = VisitTaskPlan
	TASK_PLAN_INCLUDES = { car: :staffs, region: { store: :staffs } }
	belongs_to(:car)
	belongs_to(:region)
	has_many(:order_queues)
	has_many(:visit_task_orders, dependent: :destroy)
	has_many(:orders, through: :visit_task_orders)
	has_many(:goods, through: :visit_task_orders)
	has_many(:goods_visit_task_order_ships, through: :visit_task_orders)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(
				Option.new(
						options,
						except: [
								:car_id,
								:region_id
						],
						include: [
								:staffs,
								:car,
								:region
						],
						method: :type,
						rename: {
								goods: :goods_in_task
						}
				)
		)
	end
	# @return [ActiveRecord::Relation]
	def order_task_ships
		visit_task_orders
	end
	# @return [ActiveRecord::Relation]
	def goods_task_ships
		goods_visit_task_order_ships
	end
	# @return [FalseClass, TrueClass]
	def generate(force=false)
		if datetime.past? && !generated || force
			if generated
				self.order_queues = []
				visit_task_orders.destroy_all
			end
			transaction do
				block = Proc.new do |x|
					x.visit_task = self
					x.save!
				end
				OrderQueue.issue.find_all { |x| x.order.destination.region_id == region_id }.first(send_number * 2).each(&block)
				OrderQueue.receive.find_all { |x| x.order.departure.region_id == region_id }.first(send_receive_number + send_number).each(&block)
				self.generated = true
				save!
			end
		end
	end
	# @param [OrderQueue]
	def next_order
		order_queues.first
	end
	# @param [Order] order
	# @return [Meaningless]
	def add_order(order)
		visit_task_orders << VisitTaskOrder.new(order: order)
		self.order_queues = order_queues.where(receive: !order.queue.receive) if visit_task_orders.size >= (order.queue.receive ? send_number : send_receive_number)
		save!
	end
	# @return [Meaningless]
	def check_confirm
		confirm if visit_task_orders.size >= send_receive_number || order_queues.empty?
	end
	# @return [Meaningless]
	def confirm
		self.order_queues = [] if order_queues.any?
		visit_task_orders.each do |x|
			x.goods = x.order.goods
			x.save!
		end
		self.confirmed = true
		save!
	end
	# @return [FalseClass, TrueClass]
	def check_completed
		# TODO
		return true if completed
		if self.class::CHECK_ACTION.all? { |x| partly_completed(x) }
			self.completed = true
			save!
		end
	end
	# @return [FalseClass, TrueClass]
	def partly_completed(check_action)
		# TODO
		goods_task_ships.all? { |x| x.has_check_log(check_action) }
	end
	# @param [Goods] goods
	# @param [TaskWorker] task_worker
	# @param [Hash] addition
	def edit_goods(goods, task_worker, addition)
		goods.last_action = task_worker.check_action
		case goods.last_action
			when CheckAction.leave
				goods.location = from
				goods.shelf_id = nil
			when CheckAction.load
				goods.location = car
			when CheckAction.unload
			when CheckAction.warehouse
				goods.location = to
				goods.next_stop = GoodsRouter.new(goods).next_stop
				goods.shelf_id = addition['shelf_id']
			else
				raise(ArgumentError)
		end
		goods.staff = task_worker.staff
		goods.save!
	end

	class << self
		# @param [VisitTaskPlan] plan
		# @param [Hash] task_attributes
		def generate_task_add_attributes(plan, task_attributes)
			task_attributes[:task_workers] = plan.car.staffs.collect { |x| TaskWorker.new(staff: x, check_action: CheckAction.load) }
			task_attributes[:task_workers] += plan.car.staffs.collect { |x| TaskWorker.new(staff: x, check_action: CheckAction.unload) }
			task_attributes[:task_workers] += plan.region.store.staffs.collect { |x| TaskWorker.new(staff: x, check_action: CheckAction.leave) }
			task_attributes[:task_workers] += plan.region.store.staffs.collect { |x| TaskWorker.new(staff: x, check_action: CheckAction.warehouse) }
		end
	end

end
