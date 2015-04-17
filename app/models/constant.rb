class Constant < ActiveRecord::Base
	def casted_value
		ActiveSupport::JSON.decode(value)
	end
	def casted_value=(value)
		self.value = ActiveSupport::JSON.encode(value)
	end

	class << self
		def price
			@price ||= find_by_key('price')
		end
	end

end
