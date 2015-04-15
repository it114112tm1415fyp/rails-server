class InspectTask < LogisticTask
	CHECK_ACTION = [CheckAction.inspect]
	CRON_TASK_CONTENT = Proc.new do |x1|
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
	# @param [Goods] goods
	# @param [TaskWorker] task_worker
	# @param [Hash] addition
	def edit_goods(goods, task_worker, addition)
		goods.staff = task_worker.staff
		goods.change_check_action(task_worker.check_action)
		goods.save!
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
			task_attributes[:task_workers] = plan.store.staffs.collect { |x| TaskWorker.new(staff: x, check_action: CheckAction.inspect) }
		end
	end

end
