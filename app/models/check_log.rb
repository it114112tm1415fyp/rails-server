class CheckLog < ActiveRecord::Base
	belongs_to(:check_action)
	belongs_to(:good)
	belongs_to(:staff)
	belongs_to(:location, polymorphic: true)
end
