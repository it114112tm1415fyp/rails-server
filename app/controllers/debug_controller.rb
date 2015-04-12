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
	def make_session_expired
		session[:expiry_time] = $session_expiry_time.ago.to_s
		view_session
	end
	def new_inspect_debug_task
		params_require(:staff, :store)
		render(text: InspectTask.add_debug_task(params[:staff], params[:store], params[:delay_time]).id)
	end
	def new_transfer_debug_task
		params_require(:car, :from, :to, :number)
		render(text: TransferTask.add_debug_task(params[:car], params[:from], params[:to], params[:number], params[:delay_time]).id)
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
	def test
		render(nothing: true)
	end
	private
	def only_available_at_development
		raise(NotInDevelopmentModeError) unless Rails.env.development?
	end
end
