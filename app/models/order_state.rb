class OrderState < ActiveRecord::Base
	self.table_name = 'order_status'
	has_many(:orders)

	class << self
		def after_contact
			@after_contact ||= find_by_name('after_contact')
		end
		def canceled
			@canceled ||= find_by_name('canceled')
		end
		def sending
			@sending ||= find_by_name('sending')
		end
		def sent
			@sent ||= find_by_name('sent')
		end
		def submitted
			@submitted ||= find_by_name('submitted')
		end
	end

end
