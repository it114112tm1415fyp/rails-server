class InspectTask < ActiveRecord::Base
	belongs_to(:staff)
	belongs_to(:store)
	has_many(:inspect_task_goods)
	scope(:today, Proc.new { where(datetime: Date.today.beginning_of_day..Date.today.end_of_day) })
	after_find(:generate)
	# @param [Hash] options
	# @param [NilClass, Staff] staff
	# @return [Hash]
	def as_json(options={}, staff=nil)
		super(Option.new(options, {except: [:staff_id, :store_id], include: [:staff, :store, :inspect_task_goods], method: [{action_name: {parameter: [staff]}}, :type]}))
	end
	# @param [Staff] staff
	# @return [NilClass, String]
	def action_name(staff)
		case staff
			when self.staff
				'inspect'
			else
				nil
		end
	end
	# @return [FalseClass, TrueClass]
	def generate(force=false)
		if force || (datetime.past? && !generated)
			if generated
				InspectTaskGood.destroy_all(inspect_task: self)
			end
			transaction do
				self.generated = true
				save!
				Goods.where(location: store).each { |x| InspectTaskGood.create!(inspect_task: self, goods: x) }
			end
		end
	end

	class << self
		# @return [Meaningless]
		def prepare
			unless generate_today_task
				today.find_all { |x| x.datetime.future? }.each do |x1|
					Cron.add_delayed_task(:inspect_task_generate_goods_list, x1.datetime.to_ct, x1) do |x2|
					end
				end
			end
		end
		# @param [Integer] staff_id
		# @param [Integer] store_id
		# @param [Integer] delay_time
		# @return [Integer]
		def add_debug_task(staff_id, store_id, delay_time=0)
			task_time = Time.now.at_end_of_minute + 0.000001 + delay_time.minutes
			inspect_task = create!(datetime: task_time, staff_id: staff_id, store_id: store_id)
			Cron.add_delayed_task(:inspect_task_generate_goods_list, task_time.to_ct, inspect_task) do |x1|
				Goods.where(location_id: x1.store, location_type: Store.to_s).each { |x2| InspectTaskGood.create!(inspect_task: x1, goods: x2) }
			end
			inspect_task.id
		end
		# @param [FalseClass, TrueClass] force
		# @return [FalseClass, TrueClass]
		def generate_today_task(force=false)
			now = Time.now
			need_generate = need_generate_today_task
			if result = need_generate || force
				unless need_generate
					clear_today_task
					Cron.delete(tag: :inspect_task_generate_goods_list)
				end
				today = Date.today
				day = today.cwday % 7
				today = {year: today.year, month: today.month, day: today.day}
				InspectTaskPlan.day(day).each do |x1|
					datetime = x1.time.change(today)
					inspect_task = create!(datetime: datetime, staff_id: x1.staff_id, store_id: x1.store_id)
					if datetime >= now.at_beginning_of_minute
						Cron.add_delayed_task(:inspect_task_generate_goods_list, x1.time.to_ct, inspect_task) do |x2|
							x2.generated = true
							x2.save!
							Goods.find_by_location(x2.store).each { |x3| InspectTaskGood.create!(inspect_task: x2, goods: x3) }
						end
					end
				end
			end
			result
		end
		# @return [Meaningless]
		def clear_today_task
			today.destroy_all
		end
		# @return [FalseClass, TrueClass]
		def need_generate_today_task
			today.empty?
		end
	end

end
