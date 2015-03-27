class Store < ActiveRecord::Base
	has_many(:check_logs, as: :location)
	has_many(:conveyors)
	has_many(:goods, as: :location)
	has_many(:inspect_task_plans)
	has_many(:regions)
	has_many(:staffs, as: :workplace)
	has_many(:transfer_out_tasks, as: :from, class: TransferTaskPlan)
	has_many(:transfer_in_tasks, as: :to, class: TransferTaskPlan)
	has_many(:visit_task_plans)
	scope(:enabled, Proc.new { where(enable: true) })
	validates_numericality_of(:shelf_number, greater_than: 0)
	def can_destroy
		(check_logs + conveyors + goods + staffs).size == 0
	end
	def short_name
		name
	end
	def long_name
		address
	end

	class << self
		def get_list
			enabled.collect { |x| {id: x.id, name: x.name, address: x.address, shelf_number: x.shelf_number} }
		end
		def get_map
			map = {}
			enabled.each do |x|
				map[x.id.to_s] = x.name
			end
			map
		end
	end

end
