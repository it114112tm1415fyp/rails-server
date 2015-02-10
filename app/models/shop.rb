class Shop < ActiveRecord::Base
	belongs_to(:region)
	has_many(:check_logs, as: :location)
	has_many(:goods, as: :location)
	has_many(:order_departure, as: :departure, class: Order)
	has_many(:order_destination, as: :destination, class: Order)
	def can_destroy
		(check_logs + goods + order_destination + order_departure).size == 0
	end
	def display_name
		address
	end

	class << self
		def get_list
			all.collect { |x| {id: x.id, address: x.display_name} }
		end
	end

end
