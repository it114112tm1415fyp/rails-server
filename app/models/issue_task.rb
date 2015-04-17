class IssueTask < VisitTask
	CHECK_ACTION = [CheckAction.contact, CheckAction.issue, CheckAction.leave, CheckAction.load]
	CRON_TASK_TAG = :issue_task_generate_order_list
	TASK_PLAN_CLASS = IssueTaskPlan
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, except: :received))
	end
	# @return [Array<OrderQueue>]
	def generate_order_queue
		OrderQueue.issue.find_all { |x| x.order.destination.region_id == region_id }.first(number * 2)
	end
	# @return [Meaningless]
	def check_contacted
		return unless order_queues.empty?
		visit_task_orders.each do |x|
			x.goods = x.order.goods
			x.save!
		end
		self.contacted = true
		save!
	end
	# @return [FalseClass, TrueClass]
	def partly_completed(check_action)
		case check_action
			when CheckAction.contact
				contacted
			when CheckAction.leave, CheckAction.load
				return false unless contacted
				goods_visit_task_order_ships.all? { |x| x.has_check_log(check_action) }
			when CheckAction.issue
				return false unless contacted
				visit_task_orders.all?(&:completed)
			else
				raise(ArgumentError)
		end
	end
	# @return [CheckAction] check_action
	# @return [TrueClass]
	def can_do(check_action)
		case check_action
			when CheckAction.contact
				generated && !contacted
			when CheckAction.leave, CheckAction.load, CheckAction.issue
				contacted && !completed
			else
				raise(ArgumentError)
		end
	end

	class << self
		# @param [VisitTaskPlan] plan
		# @param [Hash] task_attributes
		def generate_task_add_attributes(plan, task_attributes)
			task_attributes[:task_workers] = plan.car.staffs.collect { |x| TaskWorker.new(staff: x, check_action: CheckAction.contact) }
			task_attributes[:task_workers] += plan.car.staffs.collect { |x| TaskWorker.new(staff: x, check_action: CheckAction.load) }
			task_attributes[:task_workers] += plan.car.staffs.collect { |x| TaskWorker.new(staff: x, check_action: CheckAction.issue) }
			task_attributes[:task_workers] += plan.region.store.staffs.collect { |x| TaskWorker.new(staff: x, check_action: CheckAction.leave) }
		end
	end

end
