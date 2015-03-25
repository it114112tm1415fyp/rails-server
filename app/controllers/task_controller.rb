class TaskController < MobileApplicationController
	include(StaffMobileApplicationModule)
	before_action(:check_staff_login)
	before_action(:generate_task_if_need)
	def get_today_tasks
		tasks = []
		tasks += InspectTask.today.where(staff: @staff).collect { |x| {type: InspectTask.to_s, action: x.action_name(@staff), id: x.id, time: x.datetime.to_s(:time), store: {id: x.store.id, short_name: x.store.short_name, long_name: x.store.long_name}} }
		if @staff.workplace_type == Car.to_s
			transfer_tasks = TransferTask.today.where(car_id: @staff.workplace_id)
			visit_tasks = VisitTask.today.where(car_id: @staff.workplace_id)
		else
			transfer_tasks = TransferTask.today.where(from: @staff.workplace) + TransferTask.today.where(to: @staff.workplace)
			visit_tasks = VisitTask.today.where(store: @staff.workplace)
		end
		tasks += transfer_tasks.collect { |x| {type: TransferTask.to_s, action: x.action_name(@staff), id: x.id, time: x.datetime.to_s(:time), car: {id: x.car_id, vehicle_registration_mark: x.car.vehicle_registration_mark}, from: {type: x.from_type, id: x.from_id, short_name: x.from.short_name, long_name: x.from.long_name}, to: {type: x.to_type, id: x.to_id, short_name: x.to.short_name, long_name: x.to.long_name}} }
		tasks += visit_tasks.collect { |x| {type: VisitTask.to_s, action: x.action_name(@staff), id: x.id, time: x.datetime.to_s(:time), car: {id: x.car_id, vehicle_registration_mark: x.car.vehicle_registration_mark}, store: {id: x.store_id, name: x.store.short_name}} }
		json_response_success(tasks: tasks)
	end
	def get_details
		params_require(:task_type, :task_id)
		raise(ParameterError, 'task_type') unless [InspectTask.to_s, TransferTask.to_s, VisitTask.to_s].include?(params[:task_type])
		json_response_success(Object.const_get(params[:task_type]).get_details(params[:task_id]))
	end
	private
	def generate_task_if_need
		InspectTask.generate_today_task
		TransferTask.generate_today_task
		VisitTask.generate_today_task
	end
end
