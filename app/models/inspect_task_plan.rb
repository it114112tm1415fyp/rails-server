class InspectTaskPlan < ActiveRecord::Base
	belongs_to(:staff)
	belongs_to(:store)
	validates_numericality_of(:day, greater_than_or_equal_to: 0, less_than: 2 ** 7)
end
