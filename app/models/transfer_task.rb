class TransferTask < ActiveRecord::Base
	belongs_to(:staff)
	belongs_to(:car)
	belongs_to(:from, polymorphic: true)
	belongs_to(:to, polymorphic: true)
	scope(:today, Proc.new { where(datetime: Date.today.beginning_of_day..Date.today.end_of_day) })
	validate(:from_and_to_are_not_equal)
	validates_numericality_of(:number, greater_than: 0)
	# @param [Hash] options
	# @param [NilClass, Staff] staff
	# @return [Hash]
	def as_json(options={}, staff=nil)
		super(Option.new(options, {except: [:staff_id, :car_id, :from_id, :from_type, :to_id, :to_type], include: [:staff, :car, :from, :to], method: [:type, {action_name: {parameter: [staff]}}]}))
	end
	# @param [Staff] staff
	# @return [NilClass, String]
	def action_name(staff)
		case staff.workplace
			when car
				'load'
			when from
				'leave'
			when to
				'warehouse'
			else
				nil
		end
	end
	private
	# @return [Meaningless]
	def from_and_to_are_not_equal
		errors.add(:to, 'from and to are equal') if from == to
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
				today = { year: today.year, month: today.month, day: today.day }
				TransferTaskPlan.day(day).each do |x1|
					staffs = x1.car.staffs + x1.from.staffs + x1.to.staffs
					staffs.each do |x2|
						create!(datetime: x1.time.change(today), staff: x2, car_id: x1.car_id, from_type: x1.from_type, from_id: x1.from_id, to_type: x1.to_type, to_id: x1.to_id, number: x1.number)
					end
				end
			end
			result
		end
		# @return [Meaningless]
		def clear_today_task
			today.destroy_all
		end
		# @return [Meaningless]
		def need_generate_today_task
			!today.any?
		end
	end

end
