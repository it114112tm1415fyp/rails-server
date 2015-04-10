class FreeTime < ActiveRecord::Base
	belongs_to(:order)
	belongs_to(:receive_time_segment)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, {except: [:id, :order_id, :receive_time_segment_id], include: :receive_time_segment}))
	end
	# @return [Time]
	def version
		order.receive_time_version
	end
	# @return [FalseClass, TrueClass]
	def expiry
		version < SchemeVersion[ReceiveTimeSegment].scheme_update_time
	end
end
