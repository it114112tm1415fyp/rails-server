class TaskWorkerRole < ActiveRecord::Base
	has_many(:task_workers)
	# @param [Hash] options
	# @return [String]
	def as_json(options={})
		super(Option.new(options, collect: :name))
	end

	class << self
		# @return [self]
		def car_driver
			@car_driver ||= find_by_name!('car_driver')
		end
		# @return [self]
		def car_driver_load
			@car_driver_load ||= find_by_name!('car_driver(load)')
		end
		# @return [self]
		def car_driver_unload
			@car_driver_unload ||= find_by_name!('car_driver(unload)')
		end
		# @return [self]
		def departure_store_keeper
			@departure_store_keeper ||= find_by_name!('departure_store_keeper')
		end
		# @return [self]
		def destination_store_keeper
			@destination_store_keeper ||= find_by_name!('destination_store_keeper')
		end
		# @return [self]
		def store_keeper
			@store_keeper ||= find_by_name!('store_keeper')
		end
	end

end
