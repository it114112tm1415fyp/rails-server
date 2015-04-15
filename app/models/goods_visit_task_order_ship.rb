class GoodsVisitTaskOrderShip < GoodsTaskShip
	belongs_to(:goods, class_name: Goods)
	belongs_to(:visit_task_order)
	has_many(:check_logs, as: :task_goods, dependent: :destroy)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, only: [], include: [:goods, :order_visit_task_ship]))
	end
end
