class TransferTaskPlan < ActiveRecord::Base
	belongs_to(:car)
	belongs_to(:from, polymorphic: true)
	belongs_to(:to, polymorphic: true)
end
