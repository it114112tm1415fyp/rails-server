class TaskManager
	TASK_CLASS = [InspectTask, TransferTask, VisitTask]

	class << self
		def start
			TASK_CLASS.each(&:prepare)
			Cron.add_repeated_task(:generate_today_task, CronTime.new(0, 0)) do
				Cron.delete(tag: :inspect_task_generate_goods_list)
				Cron.delete(tag: :transfer_task_generate_goods_list)
				Cron.delete(tag: :visit_task_generate_order_list)
				TASK_CLASS.each(&:generate_today_task)
			end
		end
	end

end
