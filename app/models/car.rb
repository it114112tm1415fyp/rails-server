class Car < ActiveRecord::Base
	has_many(:check_logs, as: :location)
	has_many(:goods, as: :location)
	has_many(:staffs, as: :workplace)
	has_many(:transfer_task_plans)
	has_many(:visit_task_plans)
	scope(:enabled, Proc.new { where(enable: true) })
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Options.new(options, {only: :id, methods: [:type, :short_name, :long_name]}))
	end
	# @return [FalseClass, TrueClass]
	def can_destroy
		(check_logs + goods + staffs).size == 0
	end
	# @return [String]
	def short_name
		vehicle_registration_mark
	end
	# @return [String]
	def long_name
		vehicle_registration_mark
	end

	class << self
		# @return [Array<Hash>]
		def get_list
			enabled.collect { |x| {id: x.id, vehicle_registration_mark: x.vehicle_registration_mark} }
		end
		def get_map
			map = {}
			enabled.each do |x|
				map[x.id.to_s] = x.vehicle_registration_mark
			end
			map
		end
	end

end
