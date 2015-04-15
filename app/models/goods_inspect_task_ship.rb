class GoodsInspectTaskShip < GoodsTaskShip
	belongs_to(:inspect_task)
	belongs_to(:goods)
	has_many(:check_logs, as: :task_goods, dependent: :destroy)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, only: [], include: [:inspect_task, :goods]))
	end

	class << self
		def task
			:inspect_task
		end
	end

end
