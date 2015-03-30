class VisitTask < ActiveRecord::Base
	belongs_to(:staff)
	belongs_to(:car)
	belongs_to(:store)
	scope(:today, Proc.new { where(datetime: Date.today.beginning_of_day..Date.today.end_of_day) })
	validate(:send_number_is_less_than_or_equal_to_send_receive_number)
	validates_numericality_of(:send_number, greater_than_or_equal_to: 0)
	validates_numericality_of(:send_receive_number, greater_than: 0)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Options.new(options, {except: [:staff_id, :car_id, :store_id], include: [:staff, :car, :store]}))
	end
	# @param [Staff] staff
	# @return [String]
	def action_name(staff)
		case staff.workplace
			when car
				'load'
			when store
				'leave'
			else
				'no action'
		end
	end
	private
	def send_number_is_less_than_or_equal_to_send_receive_number
		errors.add(:send_number, 'send_number is bigger than send_receive_number') if send_number > send_receive_number
	end

	class << self
		def prepare
		end
		def get_details(id)
			{}
		end
		# @param [FalseClass, TrueClass] force
		# @return [FalseClass, TrueClass]
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
