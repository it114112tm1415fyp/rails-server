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
		render(text: Goods.get_qr_code(params[:goods_id]))
	end
	def make_session_expired
		session[:expiry_time] = $session_expiry_time.ago.to_s
		view_session
	end
	def new_inspect_task
		params_require(:staff, :store)
		render(text: InspectTask.add_debug_task(params[:staff], params[:store], params[:delay_time] || 0))
	end
	def view_cron_tasks
		render(json: Cron.tasks.collect { |x| {tag: x.tag, time: x.time.to_s} })
	end
	def view_session
		render(text: session.to_hash)
	end
	def test
		params_require(:type)
		type = params[:type]
		if id = params[:id]
			model = Object.const_get(type).find(id)
		else
			model = Object.const_get(type).all
			model = model[rand(model.size)]
		end
		p model.as_json
		render(json: model)
	end
	private
	def only_available_at_development
		raise(NotInDevelopmentModeError) unless Rails.env.development?
	end
end
