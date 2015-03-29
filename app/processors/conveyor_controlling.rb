class ConveyorControlling
	@control = []
	attr_reader(:staff_id)
	attr_reader(:expiry_time)
	# @param [Integer] staff_id
	def initialize(staff_id)
		@staff_id = staff_id
		@expiry_time = $conveyor_control_expiry_time.from_now
	end
	# @return [FalseClass, TrueClass]
	def unexpired?
		@expiry_time.future?
	end

	class << self
		# @param [Integer] conveyor_id
		# @param [Integer] staff_id
		def check(conveyor_id, staff_id)
			control = @control[conveyor_id]
			error('need control') unless control && control.unexpired? && control.staff_id == staff_id
		end
		# @param [Integer] conveyor_id
		# @param [Integer] staff_id
		def occupy(conveyor_id, staff_id)
			control = @control[conveyor_id]
			error('other user is using') if control && control.unexpired? && control.staff_id != staff_id
			@control[conveyor_id] = new(staff_id)
		end
	end

end
