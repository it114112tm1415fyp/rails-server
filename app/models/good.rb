class Good < ActiveRecord::Base
	belongs_to(:order)
	belongs_to(:location, polymorphic: true)
	has_many(:check_logs)
end
