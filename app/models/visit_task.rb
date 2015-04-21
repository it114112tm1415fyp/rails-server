class VisitTask < LogisticTask
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
								:region,
								:order_queues
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
				self.order_queues = generate_order_queue
				self.generated = true
				save!
			end
		end
	end
	# @return [Array<OrderQueue>]
	def generate_order_queue
		not_implemented
	end
	# @param [OrderQueue]
	def next_order_for_content
		order_queues.first
	end
	# @param [Order] order
	# @return [Meaningless]
	def add_order(order)
		visit_task_orders << VisitTaskOrder.new(order: order)
		self.order_queues = [] if visit_task_orders.size >= number
		save!
	end
	# @return [FalseClass, TrueClass]
	def check_completed
		return true if completed
		if self.class::CHECK_ACTION.all? { |x| partly_completed(x) }
			self.completed = true
			save!
		end
	end

	class << self
		# @param [Integer] car_id
		# @param [Integer] region_id
		# @param [Integer] number
		# @param [Integer, NilClass] delay_time
		# @return [self]
		def add_debug_task(car_id, region_id, number, delay_time)
			delay_time ||= 1
			delay_time = delay_time.to_i
			task_time = Time.now.at_beginning_of_minute + delay_time.minutes
			create!(datetime: task_time, car_id: car_id, region_id: region_id, number: number)
		end
	end

end
