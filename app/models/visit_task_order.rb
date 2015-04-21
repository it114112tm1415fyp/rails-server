class VisitTaskOrder < ActiveRecord::Base
	belongs_to(:visit_task)
	belongs_to(:order)
	has_many(:goods_visit_task_order_ships, dependent: :destroy)
	has_many(:goods, through: :goods_visit_task_order_ships)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(
				Option.new(
						options,
						except: :visit_task_id,
						include: {
								order: {
										collect: :order_state
								},
								goods: {
										collect: :string_id
								}
						},
						rename: {
								order: :order_state
						}
				)
		)
	end
	# @return [ActiveRecord::Relation]
	def goods_task_ships
		goods_visit_task_order_ships
	end
	# @param [CheckAction] check_action
	# @return [FalseClass, TrueClass]
	def partly_completed(check_action=nil)
		return false unless visit_task.contacted
		return true if completed
		self.completed = order.order_state == visit_task.class::ORDER_STATE && goods_visit_task_order_ships.any? && goods_visit_task_order_ships.all? { |x| x.has_check_log(check_action) }
		save!
		completed
	end
end
