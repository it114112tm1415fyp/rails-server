class Store < ActiveRecord::Base
	has_many(:conveyors)
	has_many(:goods, as: :location, class_name: Goods)
	has_many(:coming_goods, as: :next_stop, class_name: Goods)
	has_many(:inspect_task_plans)
	has_many(:regions)
	has_many(:staffs, as: :workplace)
	has_many(:transfer_out_task_plans, as: :from, class_name: TransferTaskPlan)
	has_many(:transfer_in_task_plans, as: :to, class_name: TransferTaskPlan)
	scope(:enabled, Proc.new { where(enable: true) })
	validates_numericality_of(:shelf_number, greater_than: 0)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, only: [:id, :shelf_number], method: [:type, :short_name, :long_name]))
	end
	# @return [FalseClass, TrueClass]
	def can_destroy
		(conveyors + goods + staffs).size == 0
	end
	# @return [String]
	def short_name
		name
	end
	# @return [String]
	def long_name
		address
	end

	class << self
		# @return [Hash]
		def get_map
			map = {}
			enabled.each do |x|
				map[x.id.to_s] = x.name
			end
			map
		end
	end

end
