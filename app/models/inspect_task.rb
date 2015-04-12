class InspectTask < Task
	CRON_TASK_CONTENT = ->(x1) do
		x1.goods.each { |x2| TASK_OBJECT_CLASS.create!(inspect_task: x1, goods: x2) }
		x1.generated = true
		x1.save!
	end
	CRON_TASK_TAG = :inspect_task_generate_goods_list
	TASK_OBJECT_CLASS = GoodsInspectTaskShip
	TASK_OBJECT_TYPE = :goods
	TASK_PLAN_CLASS = InspectTaskPlan
	belongs_to(:store)
	has_many(:goods_inspect_task_ships, dependent: :destroy)
	has_many(:goods, class: Goods, through: :goods_inspect_task_ships)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, except: :store_id, include: [:staffs, :store, :inspect_task_goods], method: :type))
	end
	def goods
		Goods.where(location: store)
	end

	class << self
		# @param [Integer] staff_id
		# @param [Integer] store_id
		# @param [Integer, NilClass] delay_time
		# @return [self]
		def add_debug_task(staff_id, store_id, delay_time)
			delay_time ||= 1
			task_time = Time.now.at_beginning_of_minute + delay_time.minutes
			inspect_task = create!(datetime: task_time, staff_id: staff_id, store_id: store_id)
			Cron.add_delayed_task(CRON_TASK_TAG, task_time.to_ct, inspect_task, &CRON_TASK_CONTENT)
			inspect_task
		end
		# @param [InspectTaskPlan] plan
		# @param [Hash] task_attributes
		def generate_task_add_attributes(plan, task_attributes)
			task_attributes[:task_workers] = plan.store.staffs.collect { |x| TaskWorker.new(staff: x, task_worker_role: TaskWorkerRole.store_keeper) }
		end
	end

end
