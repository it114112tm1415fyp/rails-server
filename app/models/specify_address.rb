class SpecifyAddress < ActiveRecord::Base
	belongs_to(:region)
	has_many(:specify_address_user_ships)
	has_many(:check_logs, as: :location)
	has_many(:goods, as: :location)
	has_many(:in_orders, as: :destination, class: Order)
	has_many(:out_orders, as: :departure, class: Order)
	has_many(:registered_users, through: :specify_address_user_ships)
	# @return [String]
	def short_name
		address + "\n" + region.name
	end
	# @return [String]
	def long_name
		address + "\n" + region.name
	end
end
