class Staff < RegisteredUser
	belongs_to(:workplace, polymorphic: true)
	has_many(:permission_staff_ships)
	has_many(:check_logs)
	has_many(:conveyor_control_logs)
	has_many(:goods)
	has_many(:orders)
	has_many(:permissions, through: :permission_staff_ships)
	validates_presence_of(:workplace)
	before_destroy do
		permission_staff_ships.each(&:destroy)
	end
	def can_destroy
		check_logs.size == 0 && orders.size == 0
	end
	def edit_account(username, password, name, email, phone, workplace_type, workplace_id, addresses, enable)
		raise(ParameterError, 'workplace_type') unless [Car.to_s, Shop.to_s, Store.to_s].include?(workplace_type)
		transaction do
			error('username used') if self.username != username && RegisteredUser.find_by_username(username)
			self.username = username
			self.password = password
			self.name = name
			self.email = email
			self.phone = phone
			self.workplace = Object.const_get(workplace_type).find(workplace_id)
			self.enable = enable
			change_address(addresses)
		end
	end

	class << self
		#@return [Staff]
		def login(username, password)
			staff = find_by_username(username)
			error('Username not exist') unless staff
			staff.check_password(password)
			error('Account frozen') unless staff.enable
			staff
		end
		def register(username, password, name, email, phone, freeze, addresses)
			ActiveRecord::Base.transaction do
				error('username used') if RegisteredUser.find_by_username(username)
				staff = create!(username: username, password: password, name: name, email: email, phone: phone, enable: freeze)
				staff.change_address(addresses)
			end
		end
	end

end
