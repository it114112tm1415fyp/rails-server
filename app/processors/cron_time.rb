class CronTime
	def initialize(hour, minute)
		@hour = hour
		@minute = minute
	end
	def succ
		self + 1
	end
	def to_i
		@hour * 60 + @minute
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

class Integer
	def to_ct
		CronTime.new(self / 60 % 24, self % 60)
	end
end

class Time
	def to_ct
		CronTime.new(hour, min)
	end
end
