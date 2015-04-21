class TransferTask < LogisticTask
	CHECK_ACTION = [CheckAction.leave, CheckAction.load, CheckAction.unload, CheckAction.warehouse]
	CRON_TASK_TAG = :transfer_task_generate_goods_list
	TASK_OBJECT_CLASS = GoodsTransferTaskShip
	TASK_OBJECT_TYPE = :goods
	TASK_PLAN_CLASS = TransferTaskPlan
	TASK_PLAN_INCLUDES = {car: :staffs}
	belongs_to(:car)
	belongs_to(:from, polymorphic: true)
	belongs_to(:to, polymorphic: true)
	has_many(:goods_transfer_task_ships, dependent: :destroy)
	has_many(:goods, class_name: Goods, through: :goods_transfer_task_ships)
	validate(:from_and_to_are_not_equal)
	validates_numericality_of(:number, greater_than: 0)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, except: [:car_id, :from_id, :from_type, :to_id, :to_type], include: [:staffs, :car, :from, :to], method: :type))
	end
	# @return [ActiveRecord::Relation]
	def goods_queue
		puts '6y'.debug6y
		p Goods.where(location: from, next_stop: to).order(id: :asc).limit(number)
	end
	# @return [ActiveRecord::Relation]
	def goods_task_ships
		goods_transfer_task_ships
	end
	private
	# @return [Meaningless]
	def from_and_to_are_not_equal
		errors.add(:to, 'from and to are equal') if from == to
	end

	class << self
		# @param [Integer] car_id
		# @param [Integer] from_location_id
		# @param [String] from_location_type
		# @param [Integer] to_location_id
		# @param [String] to_location_type
		# @param [Integer] number
		# @param [Integer, NilClass] delay_time
		# @return [self]
		def add_debug_task(car_id, from_location_id, from_location_type, to_location_id, to_location_type, number, delay_time)
			raise(ParameterError, 'from_location_type') unless [Shop.name, Store.name].include?(from_location_type)
			raise(ParameterError, 'to_location_id') unless [Shop.name, Store.name].include?(to_location_type)
			delay_time ||= 1
			delay_time = delay_time.to_i
			task_time = Time.now.at_beginning_of_minute + delay_time.minutes
			transfer_task = create!(datetime: task_time, car_id: car_id, from_id: from_location_id, from_type: from_location_type, to_id: to_location_id, to_type: to_location_type, number: number)
			Cron.add_delayed_task(CRON_TASK_TAG, task_time.to_ct, transfer_task, &:generate)
			transfer_task
		end
		# @param [TransferTaskPlan] plan
		# @param [Hash] task_attributes
		def generate_task_add_attributes(plan, task_attributes)
			task_attributes[:task_workers] = plan.from.staffs.collect { |x| TaskWorker.new(staff: x, check_action:  CheckAction.leave) }
			task_attributes[:task_workers] += plan.car.staffs.collect { |x| TaskWorker.new(staff: x, check_action: CheckAction.load) }
			task_attributes[:task_workers] += plan.car.staffs.collect { |x| TaskWorker.new(staff: x, check_action: CheckAction.unload) }
			task_attributes[:task_workers] += plan.to.staffs.collect { |x| TaskWorker.new(staff: x, check_action: CheckAction.warehouse) }
		end
	end

end
