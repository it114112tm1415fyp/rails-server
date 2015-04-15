class Shop < ActiveRecord::Base
	belongs_to(:region)
	has_many(:goods, as: :location, class_name: Goods)
	has_many(:coming_goods, as: :next_stop, class_name: Goods)
	has_many(:in_orders, as: :destination, class_name: Order)
	has_many(:out_orders, as: :departure, class_name: Order)
	has_many(:staffs, as: :workplace)
	has_many(:transfer_out_tasks, as: :from, class_name: TransferTask)
	has_many(:transfer_in_tasks, as: :to, class_name: TransferTask)
	scope(:enabled, Proc.new { where(enable: true) })
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, only: :id, include: :region, method: [:type, :short_name, :long_name]))
	end
	# @return [FalseClass, TrueClass]
	def can_destroy
		(goods + in_orders + out_orders + staffs).size == 0
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
