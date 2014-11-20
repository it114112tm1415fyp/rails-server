class ConveyorControlLog < ActiveRecord::Base
	belongs_to(:conveyor)
	belongs_to(:conveyor_control_action)
	belongs_to(:staff)
end
