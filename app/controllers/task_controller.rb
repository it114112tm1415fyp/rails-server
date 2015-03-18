class TaskController < MobileApplicationController
	include(StaffMobileApplicationModule)
	before_action(:check_staff_login)
	before_action(:generate_task_if_need)
	def get_today_tasks
		tasks = []
		tasks += InspectTask.today.where(staff: @staff).collect { |x| (p x) && {type: InspectTask.to_s, id: x.id, time: x.datetime.to_s(:time), store: {id: x.store.id, short_name: x.store.short_name, long_name: x.store.long_name}} }
		if @staff.workplace_type == Car.to_s
			tasks += TransferTask.today.where(car: @staff.workplace).collect { |x| (p x) && {type: TransferTask.to_s, id: x.id, time: x.datetime.to_s(:time), car: {id: x.car, vehicle_registration_mark: x.car.vehicle_registration_mark}, from: {type: x.from.class.to_s, id: x.from.id, short_name: x.from.short_name, long_name: x.from.long_name}, to: {type: x.to.class.to_s, id: x.to.id, short_name: x.to.short_name, long_name: x.to.long_name}} }
			tasks += VisitTask.today.where(car: @staff.workplace).collect { |x| (p x) && {type: VisitTask.to_s, id: x.id, time: x.datetime.to_s(:time), car: {id: x.car, vehicle_registration_mark: x.car.vehicle_registration_mark}, store: {id: x.store.id, name: x.store.short_name}} }
		end
		json_response_success(tasks: tasks)
	end
	def get_task_details
		params_require(:task_type, :task_id)
		raise(ParameterError, 'task_type') unless [InspectTask.to_s, TransferTask.to_s, VisitTask.to_s].include?(params[:task_type])
		const_get(params[:task_type]).get_task_details(params[:task_id])
	end
	private
	def generate_task_if_need
		InspectTask.generate_today_task
		TransferTask.generate_today_task
		VisitTask.generate_today_task
	end
end
