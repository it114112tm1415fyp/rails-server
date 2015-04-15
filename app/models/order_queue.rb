class OrderQueue < ActiveRecord::Base
	QUEUE_NAX_TIMES = 4
	belongs_to(:order)
	belongs_to(:visit_task)
	scope(:receive, -> do
		time ||= Time.new(2000,1,1,6,2)
		receive_time_segment = ReceiveTimeSegment.enabled.where("'#{time.utc.to_s(:time)}' BETWEEN #{:start_time} AND #{:end_time}").first
		where(receive: true).joins(order: :free_times).where(order: {free_times: {date: Date.today, receive_time_segment: receive_time_segment, free: true}}) if receive_time_segment
	end)
	scope(:issue, -> { where(receive: false) })
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(
				Option.new(options, only: :receive, include: :order))
	end
	# @return [Meaningless]
	def again
		if queue_times < QUEUE_NAX_TIMES
			new_queue = dup
			new_queue.queue_times += 1
			new_queue.visit_task = nil
			destroy!
			new_queue.save!
		end
	end
end
