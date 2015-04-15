class GoodsTransferTaskShip < GoodsTaskShip
	belongs_to(:transfer_task)
	belongs_to(:goods)
	has_many(:check_logs, as: :task_goods, dependent: :destroy)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, only: [], include: [:transfer_task, :goods]))
	end

	class << self
		def task
			:transfer_task
		end
	end

end
