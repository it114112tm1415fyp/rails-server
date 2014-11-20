class PermissionStaffShip < ActiveRecord::Base
	belongs_to(:permission)
	belongs_to(:registered_user)
end
