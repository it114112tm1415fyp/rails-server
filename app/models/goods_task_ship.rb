class GoodsTaskShip < ActiveRecord::Base
	GoodsTaskShip.abstract_class = true
	# @param [CheckAction] check_action
	# @return [ActiveRecord::Relation]
	def find_check_log(check_action)
		check_logs.joins(:task_worker).where(task_workers: {check_action_id: check_action.id})
	end
	# @param [CheckAction] check_action
	# @return [FalseClass, TrueClass]
	def has_check_log(check_action)
		find_check_log(check_action).any?
	end
end
