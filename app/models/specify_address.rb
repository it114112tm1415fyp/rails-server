class SpecifyAddress < ActiveRecord::Base
	belongs_to(:region)
	has_many(:specify_address_user_ships)
	has_many(:check_logs, as: :location)
	has_many(:goods, as: :location, class_name: Goods)
	has_many(:coming_goods, as: :next_stop, class_name: Goods)
	has_many(:in_orders, as: :destination, class_name: Order)
	has_many(:out_orders, as: :departure, class_name: Order)
	has_many(:registered_users, through: :specify_address_user_ships)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, only: :id, include: :region, method: [:type, :short_name, :long_name]))
	end
	# @return [String]
	def short_name
		address
	end
	# @return [String]
	def long_name
		address + "\n" + region.name
	end
end
