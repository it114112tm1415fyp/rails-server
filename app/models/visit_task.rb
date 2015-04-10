class VisitTask < ActiveRecord::Base
	belongs_to(:staff)
	belongs_to(:car)
	belongs_to(:store)
	scope(:today, Proc.new { where(datetime: Date.today.beginning_of_day..Date.today.end_of_day) })
	validate(:send_number_is_less_than_or_equal_to_send_receive_number)
	validates_numericality_of(:send_number, greater_than_or_equal_to: 0)
	validates_numericality_of(:send_receive_number, greater_than: 0)
	# @param [Hash] options
	# @param [NilClass, Staff] staff
	# @return [Hash]
	def as_json(options={}, staff=nil)
		super(Option.new(options, {except: [:staff_id, :car_id, :store_id], include: [:staff, :car, :store], method: [:type, {action_name: {parameter: [staff]}}]}))
	end
	# @param [Staff] staff
	# @return [NilClass, String]
	def action_name(staff)
		case staff.workplace
			when car
				'load'
			when store
				'leave'
			else
				nil
		end
	end
	private
	# @return [Meaningless]
	def send_number_is_less_than_or_equal_to_send_receive_number
		errors.add(:send_number, 'send_number is bigger than send_receive_number') if send_number > send_receive_number
	end

	class << self
		# @return [Meaningless]
		def prepare
		end
		# @param [FalseClass, TrueClass] force
		# @return [FalseClass, TrueClass]
		def generate_today_task(force=false)
			need_generate = need_generate_today_task
			if result = need_generate || force
				clear_today_task unless need_generate
				today = Date.today
				day = today.cwday % 7
				today = {year: today.year, month: today.month, day: today.day}
				VisitTaskPlan.day(day).each do |x1|
					x1.car.staffs.each do |x2|
						create!(datetime: x1.time.change(today), staff: x2, car_id: x1.car_id, store_id: x1.store_id, send_receive_number: x1.send_receive_number, send_number: x1.send_number)
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
			!today.any?
		end
	end

end
