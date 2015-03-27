class CronTime
	def initialize(hour, minute)
		@hour = hour
		@minute = minute
	end
	def inspect
		to_s
	end
	def succ
		self + 1
	end
	def to_i
		@hour * 60 + @minute
	end
	def to_s
		"#{'%02i' % @hour}:#{'%02i' % @minute}"
	end
	def +(other)
		(to_i + other).to_ct
	end
	def -(other)
		(to_i - other).to_ct
	end
	def ==(other)
		to_i == other.to_i
	end
	def <=>(other)
		self == other ? 0 : -1
	end

	class << self
		def now
			Time.now.to_ct
		end
	end

end
