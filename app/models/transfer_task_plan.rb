class TransferTaskPlan < ActiveRecord::Base
	belongs_to(:car)
	belongs_to(:from, polymorphic: true)
	belongs_to(:to, polymorphic: true)
	scope(:day, Proc.new { |x| where("(#{table_name}.day >> #{x}) & 1 = 1") })
	validate(:from_and_to_are_not_equal)
	validates_numericality_of(:day, greater_than_or_equal_to: 0, less_than: 2 ** 7)
	validates_numericality_of(:number, greater_than: 0)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Options.new(options, {except: [:car_id, :from_id, :from_type, :to_id, :to_type], include: [:car, :from, :to]}))
	end
	private
	def from_and_to_are_not_equal
		errors.add(:to, 'from and to are equal') if from == to
	end
end
