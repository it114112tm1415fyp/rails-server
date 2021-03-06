class DebugController < ApplicationController
	before_action(:only_available_at_development)
	def destroy_session
		view_session
		session.destroy
	end
	def edit_session
		params_require(:key, :value)
		session[params[:key]] = params[:value]
		view_session
	end
	def generate_inspect_task
		render(text: InspectTask.generate_today_task(params_exist(:force)))
	end
	def generate_transfer_task
		render(text: TransferTask.generate_today_task(params_exist(:force)))
	end
	def generate_visit_task
		render(text: VisitTask.generate_today_task(params_exist(:force)))
	end
	def generate_temporary_qr_code_for_goods
		render(text: Goods.generate_temporary_qr_code)
	end
	def get_qr_code_for_goods
		params_require(:goods_id)
		render(text: Goods.find_by_string_id(params[:goods_id]).qr_code)
	end
	def get_qr_code_for_shelf
		params_require(:shelf_id)
		render(text: 		'it114112tm1415fyp.shelf' + ActiveSupport::JSON.encode(shelf_id: params[:shelf_id]))
	end
	def make_session_expired
		session[:expiry_time] = $session_expiry_time.ago.to_s
		view_session
	end
	def new_inspect_debug_task
		params_require(:store)
		render(text: InspectTask.add_debug_task_and_worker(params[:store], params[:delay_time]).id)
	end
	def new_transfer_debug_task
		params_require(:car, :from_id, :from_type, :to_id, :to_type, :number)
		render(text: TransferTask.add_debug_task_and_worker(params[:car], params[:from_id], params[:from_type], params[:to_id], params[:to_type], params[:number], params[:delay_time]).id)
	end
	def new_receive_debug_task
		params_require(:car, :region, :number)
		render(text: ReceiveTask.add_debug_task_and_worker(params[:car], params[:region], params[:number], params[:delay_time]).id)
	end
	def receive_task_add_queue
		params_require(:task, :order)
		ReceiveTask.find(params[:task]).add_order_to_queue(Order.find(params[:order]))
		render(nothing: true)
	end
	def new_issue_debug_task
		params_require(:car, :region, :number)
		render(text: IssueTask.add_debug_task_and_worker(params[:car], params[:region], params[:number], params[:delay_time]).id)
	end
	def view_cron_tasks
		Cron.show_tasks(true)
		render(json: Cron.tasks.collect { |x| {tag: x.tag, time: x.time.to_s} })
	end
	def view_session
		render(text: session.to_hash)
	end
	def reload_extension
		ExtensionLoader.reload
		render(nothing: true)
	end
	def get_model
		type = params[:type]
		id = params[:id]
		model = Object.const_get(type).find(id)
		p model.as_json
		render(json: model)
	end
	def md5
		params_require(:value, :times)
		# @type [Integer]
		times = params[:times].to_i
		raise ParameterError('times') unless times.between?(0, 100)
		value = params[:value]
		times.times { value = Digest::MD5.hexdigest(value) }
		render(text: value)
	end
	def get_task_workers_ids
		params_require(:task_id, :task_type)
		render(json: Object.const_get(params[:task_type]).find(params[:task_id]).task_workers.as_json(only: :id, include: :check_action, merge_type: :replace))
	end
	def test
		p TransferTask.find(29).goods_queue
		render(nothing: true)
	end
	private
	def only_available_at_development
		raise(NotInDevelopmentModeError) unless Rails.env.development?
	end
end
