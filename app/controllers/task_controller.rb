class TaskController < MobileApplicationController
	include(StaffMobileApplicationModule)
	before_action(:check_staff_login)
	before_action(:generate_task_if_need)
	def get_today_tasks
		tasks = @staff.task_workers
		# tasks = []
		# tasks += InspectTask.today.where(staff: @staff)
		# case @staff.workplace_type
		# 	when Car.name
		# 		tasks += TransferTask.today.where(car_id: @staff.workplace_id, staffs: @staff)
		# 		tasks += VisitTask.today.where(car_id: @staff.workplace_id, staffs: @staff)
		# 	when Store.name, Shop.name
		# 		tasks += TransferTask.today.where(from: @staff.workplace, staffs: @staff) + TransferTask.today.where(to: @staff.workplace, staff: @staff)
		# 		tasks += VisitTask.today.where(store: @staff.workplace, staffs: @staff)
		# 	else
		# end
		response_success(tasks: tasks.sort_by { |x| x.task.datetime })
	end
	def get_details
		params_require(:task_id)
		response_success(task: TaskWorker.find(params[:task_id]))
	end
	private
	def generate_task_if_need
		InspectTask.generate_today_task
		TransferTask.generate_today_task
		VisitTask.generate_today_task
	end
end
