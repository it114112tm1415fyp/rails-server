class VisitTask < ActiveRecord::Base
	belongs_to(:staff)
	belongs_to(:car)
	belongs_to(:store)
	scope(:today, Proc.new { where(datetime: Date.today.beginning_of_day..Date.today.end_of_day) })

	class << self
		def generate_today_task(force=false)
			need_generate = need_generate_today_task
			if result = need_generate || force
				clear_today_task unless need_generate
				today = Date.today
				day = today.cwday % 7
				VisitTaskPlan.day(day).each do |x1|
					x1.car.staffs.each do |x2|
						create!(datetime: x1.time.change(year: today.year, month: today.month, day: today.day), staff: x2, car_id: x1.car_id, store_id: x1.store_id, send_receive_number: x1.send_receive_number, send_number: x1.send_number)
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
