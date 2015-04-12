class TaskWorker < ActiveRecord::Base
	belongs_to(:staff)
	belongs_to(:task, polymorphic: true)
	belongs_to(:task_worker_role)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, only: [:id], collect: {task: {except: :id}}, method: :action))
	end
	# @return [String]
	def action
		case task_type
			when InspectTask.name
				CheckAction.inspect.name
			when TransferTask.name
				case task_worker_role
					when TaskWorkerRole.car_driver_load
						CheckAction.load.name
					when TaskWorkerRole.car_driver_unload
						CheckAction.unload.name
					when TaskWorkerRole.departure_store_keeper
						CheckAction.leave.name
					when TaskWorkerRole.destination_store_keeper
						CheckAction.warehouse.name
					else
						raise(ArgumentError)
				end
			when VisitTask.name
				case task_worker_role
					when TaskWorkerRole.car_driver
						CheckAction.load.name || CheckAction.unload.name
					when TaskWorkerRole.store_keeper
						CheckAction.leave.name
					else
						raise(ArgumentError)
				end
			else
				raise(ArgumentError)
		end
	end
end
