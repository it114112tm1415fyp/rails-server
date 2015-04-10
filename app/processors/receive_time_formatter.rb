class ReceiveTimeFormatter
	class << self
		# @param [FreeTime::ActiveRecord_AssociationRelation] time
		# @return [Hash]
		def format(time)
			dates = time.collect(&:date).uniq
			receive_time_segments = time.collect(&:receive_time_segment).uniq
			free = time.group_by(&:date).values.collect { |x| x.collect(&:free) }
			{ dates: dates, receive_time_segments: receive_time_segments, free: free }
		end
	end
end
