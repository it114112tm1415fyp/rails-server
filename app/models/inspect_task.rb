class InspectTask < ActiveRecord::Base
	belongs_to(:staff)
	belongs_to(:store)
	has_many(:inspect_task_goods)
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
	def get_details
		{
				datetime: datetime,
				staff: {
						id: staff_id,
						name: staff.name,
						email: staff.email,
						phone: staff.phone,
						workplace: {
								id: staff.workplace_id,
								type: staff.workplace_type,
								short_name: staff.workplace.short_name,
								long_name: staff.workplace.long_name
						}
				},
				store: {
						id: store_id,
						short_name: store.short_name,
						long_name: store.long_name
				},
				goods: inspect_task_goods.collect { |x| {
						id: x.good.string_id,
						order_id: x.good.order_id,
						location: {
								id: x.good.location_id,
								type: x.good.location_type,
								short_name: x.good.location.short_name,
								long_name: x.good.location.long_name
						},
						last_action: x.good.last_action.name,
						last_action_staff: x.good.staff,
						complete: x.complete
				} },
				generated: generated,
				complete: complete
		}
	end

	class << self
		def prepare
			unless generate_today_task
				today.find_all { |x| x.datetime.future? }.each do |x1|
					Cron.add_delayed_task(:inspect_task_generate_good_list, x1.datetime.to_ct, x1) do |x2|
						x2.generated = true
						x2.save!
						Good.find_by_location(x2.store).each { |x3| InspectTaskGood.create!(inspect_task: x2, good: x3) }
					end
				end
			end
		end
		def add_debug_task(staff_id, store_id, delay_time=0)
			task_time = Time.now.at_end_of_minute + 0.000001 + delay_time.minutes
			inspect_task = create!(datetime: task_time, staff_id: staff_id, store_id: store_id)
			Cron.add_delayed_task(:inspect_task_generate_good_list, task_time.to_ct, inspect_task) do |x1|
				Good.where(location_id: x1.store, location_type: Store.to_s).each { |x2| InspectTaskGood.create!(inspect_task: x1, good: x2) }
			end
			inspect_task.id
		end
		def get_details(id)
			find(id).get_details
		end
		def generate_today_task(force=false)
			need_generate = need_generate_today_task
			if result = need_generate || force
				unless need_generate
					clear_today_task
					Cron.delete(tag: :inspect_task_generate_good_list)
				end
				today = Date.today
				day = today.cwday % 7
				today = {year: today.year, month: today.month, day: today.day}
				InspectTaskPlan.day(day).each do |x1|
					inspect_task = create!(datetime: x1.time.change(today), staff_id: x1.staff_id, store_id: x1.store_id)
					p Time
					p x1.time.class
					Cron.add_delayed_task(:inspect_task_generate_good_list, x1.time.to_ct, inspect_task) do |x2|
						x2.generated = true
						x2.save!
						Good.find_by_location(x2.store).each { |x3| InspectTaskGood.create!(inspect_task: x2, good: x3) }
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
