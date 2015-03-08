class Shop < ActiveRecord::Base
	belongs_to(:region)
	has_many(:check_logs, as: :location)
	has_many(:goods, as: :location)
	has_many(:in_orders, as: :destination, class: Order)
	has_many(:out_orders, as: :departure, class: Order)
	has_many(:staffs, as: :workplace)
	has_many(:transfer_out_tasks, as: :from)
	has_many(:transfer_in_tasks, as: :to)
	scope(:enabled, Proc.new { where(enable: true) })
	def can_destroy
		(check_logs + goods + in_orders + out_orders + staffs).size == 0
	end
	def short_name
		name
	end
	def long_name
		address
	end

	class << self
		def get_list
			enabled.collect { |x| {id: x.id, name: x.name, address: x.address} }
		end
		def get_map
			map = {}
			enabled.each do |x|
				map[x.id.to_s] = x.name
			end
			map
		end
	end

end
