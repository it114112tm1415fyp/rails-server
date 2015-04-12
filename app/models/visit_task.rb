class VisitTask < Task
	CRON_TASK_CONTENT = ->(x1) do
		x1.goods.each { |x2| TASK_OBJECT_CLASS.create!(visit_task: x1, goods: x2) }
		x1.generated = true
		x1.save!
	end
	CRON_TASK_TAG = :visit_task_generate_goods_list
	TASK_OBJECT_CLASS = OrderVisitTaskShip
	TASK_OBJECT_TYPE = :order
	TASK_PLAN_CLASS = VisitTaskPlan
	TASK_PLAN_INCLUDES = {car: :staffs}
	belongs_to(:car)
	belongs_to(:store)
	has_many(:order_visit_task_ships, dependent: :destroy)
	has_many(:orders, through: :order_visit_task_ships)
	validate(:send_number_is_less_than_or_equal_to_send_receive_number)
	validates_numericality_of(:send_number, greater_than_or_equal_to: 0)
	validates_numericality_of(:send_receive_number, greater_than: 0)
	# @param [Hash] options
	# @param [NilClass, Staff] staff
	# @return [Hash]
	def as_json(options={}, staff=nil)
		super(Option.new(options, except: [:car_id, :store_id], include: [:staffs, :car, :store], method: :type))
	end
	# @return [ActiveRecord::Relation]
	def order
		#Order.sending.joins([:goods, {destination: :region}]).where(store: store).limit(send_number)
		#Order.submitted.joins(departure: :region).where(departure: {region: {store: store}})
	end
	private
	# @return [Meaningless]
	def send_number_is_less_than_or_equal_to_send_receive_number
		errors.add(:send_number, 'send_number is bigger than send_receive_number') if send_number > send_receive_number
	end

	class << self
		# @param [VisitTaskPlan] plan
		# @param [Hash] task_attributes
		def generate_task_add_attributes(plan, task_attributes)
			task_attributes[:task_workers] = plan.car.staffs.collect { |x| TaskWorker.new(staff: x, task_worker_role: TaskWorkerRole.car_driver) }
			task_attributes[:task_workers] += plan.store.staffs.collect { |x| TaskWorker.new(staff: x, task_worker_role: TaskWorkerRole.store_keeper) }
		end
	end

end
