class Integer
	def to_ct
		CronTime.new(self / 60 % 24, self % 60)
	end
end
