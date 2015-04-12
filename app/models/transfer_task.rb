class TransferTask < Task
	CRON_TASK_CONTENT = ->(x1) do
		x1.goods.each { |x2| TASK_OBJECT_CLASS.create!(transfer_task: x1, goods: x2) }
		x1.generated = true
		x1.save!
	end
	CRON_TASK_TAG = :transfer_task_generate_goods_list
	TASK_OBJECT_CLASS = GoodsTransferTaskShip
	TASK_OBJECT_TYPE = :goods
	TASK_PLAN_CLASS = TransferTaskPlan
	TASK_PLAN_INCLUDES = {car: :staffs}
	belongs_to(:car)
	belongs_to(:from, polymorphic: true)
	belongs_to(:to, polymorphic: true)
	has_many(:goods_transfer_task_ships, dependent: :destroy)
	has_many(:goods, class: Goods, through: :goods_transfer_task_ships)
	validate(:from_and_to_are_not_equal)
	validates_numericality_of(:number, greater_than: 0)
	# @param [Hash] options
	# @param [NilClass, Staff] staff
	# @return [Hash]
	def as_json(options={}, staff=nil)
		super(Option.new(options, except: [:car_id, :from_id, :from_type, :to_id, :to_type], include: [:staffs, :car, :from, :to], method: :type))
	end
	# @return [ActiveRecord::Relation]
	def goods
		Goods.where(location: from, next_stop: to).limit(number)
	end
	private
	# @return [Meaningless]
	def from_and_to_are_not_equal
		errors.add(:to, 'from and to are equal') if from == to
	end

	class << self
		# @param [Integer] car_id
		# @param [Integer] from_location_id
		# @param [Integer] to_location_id
		# @param [Integer] number
		# @param [Integer, NilClass] delay_time
		# @return [self]
		def add_debug_task(car_id, from_location_id, to_location_id, number, delay_time)
			delay_time ||= 1
			car = Car.find(car_id)
			task_time = Time.now.at_beginning_of_minute + delay_time.minutes
			transfer_task = create!(datetime: task_time, staff: car.staffs.first, car_id: car_id, from_id: from_location_id, to_id: to_location_id, number: number)
			Cron.add_delayed_task(CRON_TASK_TAG, task_time.to_ct, transfer_task, &CRON_TASK_CONTENT)
			transfer_task
		end
		# @param [TransferTaskPlan] plan
		# @param [Hash] task_attributes
		def generate_task_add_attributes(plan, task_attributes)
			task_attributes[:task_workers] = plan.car.staffs.collect { |x| TaskWorker.new(staff: x, task_worker_role: TaskWorkerRole.car_driver_load) }
			task_attributes[:task_workers] += plan.car.staffs.collect { |x| TaskWorker.new(staff: x, task_worker_role: TaskWorkerRole.car_driver_unload) }
			task_attributes[:task_workers] += plan.from.staffs.collect { |x| TaskWorker.new(staff: x, task_worker_role:  TaskWorkerRole.departure_store_keeper) }
			task_attributes[:task_workers] += plan.to.staffs.collect { |x| TaskWorker.new(staff: x, task_worker_role: TaskWorkerRole.destination_store_keeper) }
		end
	end

end
