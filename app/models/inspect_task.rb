class InspectTask < LogisticTask
	CHECK_ACTION = [CheckAction.inspect]
	CRON_TASK_TAG = :inspect_task_generate_goods_list
	TASK_OBJECT_CLASS = GoodsInspectTaskShip
	TASK_OBJECT_TYPE = :goods
	TASK_PLAN_CLASS = InspectTaskPlan
	belongs_to(:store)
	has_many(:goods_inspect_task_ships, dependent: :destroy)
	has_many(:goods, class_name: Goods, through: :goods_inspect_task_ships)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, except: :store_id, include: [:staffs, :store, {goods: {collect: :string_id, merge_type: :replace}}], method: :type, rename: {goods: :goods_ids}))
	end
	def goods_queue
		Goods.where(location: store)
	end
	# @return [ActiveRecord::Relation]
	def goods_task_ships
		goods_inspect_task_ships
	end

	class << self
		# @param [Integer] store_id
		# @param [Integer, NilClass] delay_time
		# @return [self]
		def add_debug_task(store_id, delay_time)
			delay_time ||= 1
			delay_time = delay_time.to_i
			task_time = Time.now.at_beginning_of_minute + delay_time.minutes
			inspect_task = create!(datetime: task_time, store_id: store_id)
			Cron.add_delayed_task(CRON_TASK_TAG, task_time.to_ct, inspect_task, &:generate)
			inspect_task
		end
		# @param [InspectTaskPlan] plan
		# @param [Hash] task_attributes
		def generate_task_add_attributes(plan, task_attributes)
			task_attributes[:task_workers] = plan.store.staffs.collect { |x| TaskWorker.new(staff: x, check_action: CheckAction.inspect) }
		end
	end

end
