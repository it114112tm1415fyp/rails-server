class Permission < ActiveRecord::Base
	has_many(:users, through: :permission_user_ships)
end
