class Time
	def to_ct
		CronTime.new(hour, min)
	end
end
