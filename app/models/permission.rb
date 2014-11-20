class Permission < ActiveRecord::Base
	has_many(:registered_users, through: :PermissionStaffShip)
end
