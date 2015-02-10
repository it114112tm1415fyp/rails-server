class Car < ActiveRecord::Base
	has_many(:check_logs, as: :location)
	has_many(:goods, as: :location)
	has_many(:worker, class: Staff)
	before_destroy do
		worker.each { |x| x.car = nil }
	end
	def driver
		worker && worker.find(&:driver)
	end
	def helper
		worker && worker.find{ |x| !x.driver }
	end
	def display_name
		vehicle_registration_mark
	end

	class << self
		def get_list
			all.collect{ |x| {id: x.id, vehicle_registration_mark: x.vehicle_registration_mark} }
		end
	end

end
