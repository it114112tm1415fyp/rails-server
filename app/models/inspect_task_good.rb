class InspectTaskGood < ActiveRecord::Base
	belongs_to(:inspect_task)
	belongs_to(:goods)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, {except: [:id, :inspect_task_id, :goods_id], include: {goods: {collect: :string_id, marge_type: :replace}}, rename: {goods: :goods_id}}))
	end
end
