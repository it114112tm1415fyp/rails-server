class TransferTaskWorker < ActiveRecord::Base
	belongs_to(:staff)
	belongs_to(:transfer_task)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, only: [], include: [:staff, :transfer_task]))
	end
end
