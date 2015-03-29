class OrderState < ActiveRecord::Base
	self.table_name = 'order_status'
	has_many(:orders)

	class << self
		# @return [self]
		def confirmed
			@confirmed ||= find_by_name!('confirmed')
		end
		# @return [self]
		def canceled
			@canceled ||= find_by_name!('canceled')
		end
		# @return [self]
		def sending
			@sending ||= find_by_name!('sending')
		end
		# @return [self]
		def sent
			@sent ||= find_by_name!('sent')
		end
		# @return [self]
		def submitted
			@submitted ||= find_by_name!('submitted')
		end
	end

end
