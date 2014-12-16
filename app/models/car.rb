class Car < ActiveRecord::Base
	belongs_to(:driver, class_name: 'Staff')
	belongs_to(:partner, class_name: 'Staff')
	has_many(:check_logs, as: :location)
	has_many(:goods, as: :location)
	def display_name
		vehicle_registration_mark
	end
end
