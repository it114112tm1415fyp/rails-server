class VisitTaskPlan < ActiveRecord::Base
	belongs_to(:car)
	belongs_to(:region)
	scope(:day, Proc.new { |x| where("(#{table_name}.day >> #{x}) & 1 = 1") })
	validates_numericality_of(:day, greater_than_or_equal_to: 0, less_than: 2 ** 7)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, except: [:car_id, :region_id], include: [:type, :car, :region]))
	end
end
