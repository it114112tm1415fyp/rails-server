class VisitTaskPlan < ActiveRecord::Base
	belongs_to(:car)
	belongs_to(:store)
	validates_numericality_of(:send_number, greater_than_or_equal_to: 0)
	validates_numericality_of(:send_receive_number, greater_than: 0)
end
