class Staff < RegisteredUser
	has_many(:permission_staff_ships)
	has_many(:check_logs)#, foreign_key: :staff_id)
	has_many(:conveyor_control_logs)
	has_many(:permissions, through: :permission_staff_ships)

	class << self
		#@return [Staff]
		def login(username, password)
			return admin_login(password) if username == $admin_username
			staff = find_by_username(username)
			error('Username not exist') unless staff
			staff.check_password(password)
			error('Account frozen') if staff.is_freeze
			staff
		end
		#@return [Staff]
		def admin_login(password)
			admin = find_by(username: $admin_username)
			admin = create!(username: $admin_username, password: $admin_password) unless admin
			admin.check_password(password)
			admin
		end
	end

end
