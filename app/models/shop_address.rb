class ShopAddress < ActiveRecord::Base
	has_many(:check_logs, as: :location)
	has_many(:order_destination, as: :location)
	has_many(:order_departure, as: :location)
	has_many(:goods, as: :location)
	def display_name
		address
	end
end
