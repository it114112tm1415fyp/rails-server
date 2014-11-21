class Staff < RegisteredUser
	has_many(:permission_staff_ships)
	has_many(:check_logs)#, foreign_key: :staff_id)
	has_many(:conveyor_control_logs)
	has_many(:permissions, through: :permission_staff_ships)

	class << self
		def login(username, password)
			staff = find_by_username(username)
			error('username not exist') unless staff
			staff.check_password(password)
			error('account frozen') if staff.is_freeze
			staff
		end
	end

end
