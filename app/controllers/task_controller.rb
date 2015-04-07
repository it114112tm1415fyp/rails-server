class TaskController < MobileApplicationController
	include(StaffMobileApplicationModule)
	before_action(:check_staff_login)
	before_action(:generate_task_if_need)
	def get_today_tasks
		tasks = []
		tasks += InspectTask.today.where(staff: @staff)
		case @staff.workplace_type
			when Car.name
				tasks += TransferTask.today.where(car_id: @staff.workplace_id, staff: @staff)
				tasks += VisitTask.today.where(car_id: @staff.workplace_id, staff: @staff)
			when Store.name, Shop.name
				tasks += TransferTask.today.where(from: @staff.workplace, staff: @staff) + TransferTask.today.where(to: @staff.workplace, staff: @staff)
				tasks += VisitTask.today.where(store: @staff.workplace, staff: @staff)
			else
		end
		response_success(tasks: tasks.sort_by { |x| x.datetime }.collect { |x| x.as_json({}, @staff) })
	end
	def get_details
		params_require(:task_type, :task_id)
		raise(ParameterError, 'task_type') unless [InspectTask.to_s, TransferTask.to_s, VisitTask.to_s].include?(params[:task_type])
		response_success(task: Object.const_get(params[:task_type]).find(params[:task_id]).as_json({}, @staff))
	end
	private
	def generate_task_if_need
		InspectTask.generate_today_task
		TransferTask.generate_today_task
		VisitTask.generate_today_task
	end
end
