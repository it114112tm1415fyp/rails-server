class TaskManager
	TASK_CLASS = [InspectTask, TransferTask, ReceiveTask, IssueTask, ServeTask]

	class << self
		def start
			TASK_CLASS.each(&:prepare)
			Cron.add_repeated_task(:generate_today_task, CronTime.new(0, 0)) do
				TASK_CLASS.each { |x| Cron.delete(tag: x::CRON_TASK_TAG) if x::CRON_TASK_TAG }
				TASK_CLASS.each(&:generate_today_task)
			end
		end
	end

end
