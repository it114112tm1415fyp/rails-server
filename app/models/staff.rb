class Staff < RegisteredUser
	belongs_to(:car)
	has_many(:permission_staff_ships)
	has_many(:check_logs)
	has_many(:conveyor_control_logs)
	has_many(:orders)
	has_many(:permissions, through: :permission_staff_ships)
	before_destroy do
		permission_staff_ships.each(&:destroy)
	end
	def can_destroy
		check_logs.size == 0 && orders.size == 0
	end
	def partner
		car && (driver ? car.helper : car.driver)
	end
	def role
		driver ? 'driver' : 'helper'
	end

	class << self
		#@return [Staff]
		def login(username, password)
			return admin if admin = Admin.try_login(username, password)
			staff = find_by_username(username)
			error('Username not exist') unless staff
			staff.check_password(password)
			error('Account frozen') if staff.is_freeze
			staff
		end
		def register(username, password, name, email, phone, freeze, addresses)
			ActiveRecord::Base.transaction do
				error('username used') if RegisteredUser.find_by_username(username)
				staff = create!(username: username, password: password, name: name, email: email, phone: phone, is_freeze: freeze)
				staff.change_address(addresses)
			end
		end
	end

end
