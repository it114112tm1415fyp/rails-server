class Time
	# @return [CronTime]
	def to_ct
		CronTime.new(hour, min)
	end
end
