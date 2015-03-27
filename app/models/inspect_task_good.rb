class InspectTaskGood < ActiveRecord::Base
	belongs_to(:inspect_task)
	belongs_to(:good)
end
