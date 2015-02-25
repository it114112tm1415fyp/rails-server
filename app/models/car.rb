class Car < ActiveRecord::Base
	has_many(:check_logs, as: :location)
	has_many(:goods, as: :location)
	has_many(:staffs, as: :workplace)
	scope(:enabled, Proc.new { where(enable: true) })
	def can_destroy
		(check_logs + goods + staffs).size == 0
	end
	def name
		vehicle_registration_mark
	end
	def long_name
		vehicle_registration_mark
	end

	class << self
		def get_list
			enabled.collect { |x| {id: x.id, vehicle_registration_mark: x.vehicle_registration_mark} }
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
