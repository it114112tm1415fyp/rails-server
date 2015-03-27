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
				unless need_generate
					clear_today_task
					Cron.delete(tag: :inspect_task_generate_good_list)
				end
				today = Date.today
				today = {year: today.year, month: today.month, day: today.day}
				day = today.cwday % 7
				InspectTaskPlan.day(day).each do |x|
					inspect_task = create!(datetime: x.time.change(today), staff_id: x.staff_id, store_id: x.store_id)
					Cron.add_delayed_task(:inspect_task_generate_good_list, x.time.to_ct, inspect_task) do |x1|
						Good.find_by_location(x1.store).each { |x2| InspectTaskGood.create!(inspect_task: x1, good: x2) }
					end
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
