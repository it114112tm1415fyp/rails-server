class Shop < ActiveRecord::Base
	belongs_to(:region)
	has_many(:check_logs, as: :location)
	has_many(:goods, as: :location, class: Goods)
	has_many(:in_orders, as: :destination, class: Order)
	has_many(:out_orders, as: :departure, class: Order)
	has_many(:staffs, as: :workplace)
	has_many(:transfer_out_tasks, as: :from, class: TransferTask)
	has_many(:transfer_in_tasks, as: :to, class: TransferTask)
	scope(:enabled, Proc.new { where(enable: true) })
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, {only: :id, include: :region, method: [:type, :short_name, :long_name]}))
	end
	# @return [FalseClass, TrueClass]
	def can_destroy
		(check_logs + goods + in_orders + out_orders + staffs).size == 0
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
