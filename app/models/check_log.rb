class CheckLog < ActiveRecord::Base
	belongs_to(:task_worker)
	belongs_to(:task_goods, polymorphic: true)
	before_validation { self.time = Time.current }
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, except: [:task_worker_id, :task_goods_id, :task_goods_type], include: {task_worker: {collect: :staff, merge_type: :replace}}, method: :check_action, rename: {task_worker: :staff}))
	end
	def check_action
		task_worker.check_action
	end
end
