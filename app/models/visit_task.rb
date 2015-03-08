class VisitTaskPlan < ActiveRecord::Base
	belongs_to(:car)
	belongs_to(:store)
end
