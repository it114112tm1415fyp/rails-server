class ConveyorControlAction < ActiveRecord::Base
	has_many(:conveyor_control_logs)
end
