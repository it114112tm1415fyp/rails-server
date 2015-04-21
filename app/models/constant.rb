class Constant < ActiveRecord::Base
	def casted_value
		ActiveSupport::JSON.decode(value)
	end
	def casted_value=(value)
		self.value = ActiveSupport::JSON.encode(value)
		save!
	end

	class << self
		# @return [self]
		def price_base
			@price_base ||= find_by_key('price_base')
		end
		# @return [self]
		def price_for_weight
			@price_for_weight ||= find_by_key('price_for_weight')
		end
	end

end
