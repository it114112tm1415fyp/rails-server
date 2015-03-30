class InspectTaskgoods < ActiveRecord::Base
	belongs_to(:inspect_task)
	belongs_to(:goods)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Options.new(options, {except: :goods_id, include: :goods}))
	end
end
