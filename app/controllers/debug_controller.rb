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
		render(text: Good.generate_temporary_qr_code)
	end
	def get_qr_code_for_goods
		params_require(:good_id)
		render(text: Good.get_qr_code(params[:good_id]))
	end
	def make_session_expired
		session[:expiry_time] = $session_expiry_time.ago.to_s
		view_session
	end
	def view_session
		render(text: session.to_hash)
	end
	private
	def only_available_at_development
		raise(NotInDevelopmentModeError) unless Rails.env.development?
	end
end
