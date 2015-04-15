class TaskController < MobileApplicationController
	include(StaffMobileApplicationModule)
	before_action(:check_staff_login)
	before_action(:generate_task_if_need)
	def do_task
		params_require(:task_id, :goods_id)
		TaskWorker.find(params[:task_id]).do_task(params[:goods_id], params[:addition])
	end
	def contact
		params_require(:task_id, :order_id, :customer_free)
		TaskWorker.find(params[:task_id]).contact(params[:order_id], params[:customer_free])
	end
	def visit_task_get_next_order
		params_require(:task_id)
		response_success(TaskWorker.find(params[:task_id]).task.next_order)
	end
	def get_today_tasks
		response_success(@staff.today_task_workers.sort_by { |x| x.task.datetime })
	end
	def get_details
		params_require(:task_id)
		response_success(TaskWorker.find(params[:task_id]))
	end
	# def inspect
	# 	params_require(:task_id, :goods_id, :store_id)
	# 	Goods.inspect(params[:task_id], params[:goods_id], params[:store_id], @staff)
	# end
	# def leave
	# 	params_require(:task_id, :goods_id, :location_id, :location_type)
	# 	Goods.leave(params[:task_id], params[:goods_id], params[:location_id], params[:location_type], @staff)
	# end
	# def load
	# 	params_require(:task_id, :goods_id, :car_id)
	# 	Goods.load(params[:task_id], params[:goods_id], params[:car_id], @staff)
	# end
	# def unload
	# 	params_require(:task_id, :goods_id, :car_id)
	# 	Goods.unload(params[:task_id], params[:goods_id], params[:car_id], @staff)
	# end
	# def warehouse
	# 	params_require(:task_id, :goods_id, :location_id, :location_type)
	# 	Goods.warehouse(params[:task_id], params[:goods_id], params[:location_id], params[:location_type], @staff)
	# end
	private
	def generate_task_if_need
		TaskManager::TASK_CLASS.each(&:generate_today_task)
	end
end
