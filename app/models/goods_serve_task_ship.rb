class GoodsServeTaskShip < GoodsTaskShip
	belongs_to(:serve_task)
	belongs_to(:goods)
	has_many(:check_logs, as: :task_goods)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, only: [], include: [:serve_task, :goods]))
	end

	class << self
		def task
			:serve_task
		end
	end

end
