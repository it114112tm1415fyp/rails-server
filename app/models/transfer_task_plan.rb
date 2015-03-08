class TransferTaskPlan < ActiveRecord::Base
	belongs_to(:car)
	belongs_to(:from, polymorphic: true)
	belongs_to(:to, polymorphic: true)
	validate(:from_and_to_are_not_equal)
	validates_numericality_of(:number, greater_than: 0)
	def from_and_to_are_not_equal
		errors.add(:to, 'from and to are equal') if from == to
	end
end
