class OrderVisitTaskShip < ActiveRecord::Base
	belongs_to(:visit_task)
	belongs_to(:order)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, except: [:id, :visit_task_id, :order_id], include: {order: {collect: :id, marge_type: :replace}}, rename: {order: :order_id}))
	end
end
