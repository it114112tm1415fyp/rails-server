class CheckLog < ActiveRecord::Base
	belongs_to(:check_action)
	belongs_to(:good)
	belongs_to(:staff, class_name: :User, foreign_key: :staff_id)
	belongs_to(:venue, class_name: :Address, foreign_key: :venue_id)
end
