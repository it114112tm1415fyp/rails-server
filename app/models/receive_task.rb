class ReceiveTask < VisitTask
	CHECK_ACTION = [CheckAction.contact, CheckAction.receive, CheckAction.unload, CheckAction.warehouse]
	CRON_TASK_TAG = :receive_task_generate_order_list
	TASK_PLAN_CLASS = ReceiveTaskPlan
	# @return [Array<OrderQueue>]
	def generate_order_queue
		OrderQueue.receive.find_all { |x| x.order.departure.region_id == region_id }.first(number * 2)
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
	# @return [Meaningless]
	def check_received
		return unless partly_completed(CheckAction.receive)
		self.received = true
		save!
	end
	# @return [FalseClass, TrueClass]
	def partly_completed(check_action)
		case check_action
			when CheckAction.contact
				contacted
			when CheckAction.unload, CheckAction.warehouse
				return false unless received
				goods_visit_task_order_ships.all? { |x| x.has_check_log(check_action) }
			when CheckAction.receive
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
			when CheckAction.receive
				contacted && !completed
			when CheckAction.unload, CheckAction.warehouse
				received && !completed
			else
				raise(ArgumentError)
		end
	end

	class << self
		# @param [VisitTaskPlan] plan
		# @param [Hash] task_attributes
		def generate_task_add_attributes(plan, task_attributes)
			task_attributes[:task_workers] = plan.car.staffs.collect { |x| TaskWorker.new(staff: x, check_action: CheckAction.contact) }
			task_attributes[:task_workers] += plan.car.staffs.collect { |x| TaskWorker.new(staff: x, check_action: CheckAction.unload) }
			task_attributes[:task_workers] += plan.car.staffs.collect { |x| TaskWorker.new(staff: x, check_action: CheckAction.receive) }
			task_attributes[:task_workers] += plan.region.store.staffs.collect { |x| TaskWorker.new(staff: x, check_action: CheckAction.warehouse) }
		end
	end

end
