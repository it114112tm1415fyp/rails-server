class SpecifyAddress < ActiveRecord::Base
	has_many(:specify_addresses_user_ships)
	has_many(:check_logs, as: :location)
	has_many(:goods, as: :location)
	has_many(:registered_users, through: :specify_addresses_user_ships)
	def display_name
		address
	end
end
