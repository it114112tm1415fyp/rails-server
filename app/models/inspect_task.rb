class InspectTask < ActiveRecord::Base
	belongs_to(:staff)
	belongs_to(:store)
	scope(:today, Proc.new { where(datetime: Date.today.beginning_of_day..Date.today.end_of_day) })
	#@param [Staff] staff
	def action_name(staff)
		case staff
			when self.staff
				'inspect'
			else
				'no action'
		end
	end

	class << self
		def get_details(id)
			{}
		end
		def generate_today_task(force=false)
			need_generate = need_generate_today_task
			if result = need_generate || force
				clear_today_task unless need_generate
				today = Date.today
				day = today.cwday % 7
				InspectTaskPlan.day(day).each do |x|
					create!(datetime: x.time.change(year: today.year, month: today.month, day: today.day), staff_id: x.staff_id, store_id: x.store_id)
				end
			end
			result
		end
		def clear_today_task
			today.destroy_all
		end
		def need_generate_today_task
			!today.any?
		end
	end

end
