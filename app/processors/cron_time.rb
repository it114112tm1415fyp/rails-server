class CronTime
	# @param [Integer] hour
	# @param [Integer] minute
	def initialize(hour, minute)
		raise(ArgumentError) unless hour.between?(0,23) && minute.between?(0,59)
		@hour = hour
		@minute = minute
	end
	# @return [String]
	def inspect
		to_s
	end
	# @return [self]
	def succ
		self + 1
	end
	# @return [Integer]
	def to_i
		@hour * 60 + @minute
	end
	# @return [String]
	def to_s
		"#{'%02i' % @hour}:#{'%02i' % @minute}"
	end
	# @param [Integer] other
	# @return [self]
	def +(other)
		(to_i + other).to_ct
	end
	# @param [Integer] other
	# @return [self]
	def -(other)
		(to_i - other).to_ct
	end
	# @param [self] other
	# @return [FalseClass, TrueClass]
	def ==(other)
		to_i == other.to_i
	end
	# @param [self] other
	# @return [Integer]
	def <=>(other)
		self == other ? 0 : -1
	end

	class << self
		# @return [self]
		def now
			Time.now.to_ct
		end
	end

end
