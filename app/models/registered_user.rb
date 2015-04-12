class RegisteredUser < ActiveRecord::Base
	has_many(:specify_address_user_ships, as: :user)
	has_many(:specify_addresses, through: :specify_address_user_ships)
	has_many(:receive_orders, as: :receiver, class: Order)
	has_many(:send_orders, class: Order, foreign_key: :sender_id)
	validates_format_of(:email, with: /("[^"]+?"|[\da-z]|[\da-z](\.?[\w\$\*\+\-\/\?\^\{\|\}!#%&'=`~]+)*[\da-z])@(\[((0|[1-9]\d?|1\d\d|2[0-4]\d|25[0-5])\.){3}(0|[1-9]\d?|1\d\d|2[0-4]\d|25[0-5])\]|(([\da-z]|[\da-z][\w\-]*[\da-z])\.)+[\da-z]{2,24})/i)
	validates_format_of(:password, with: /[\da-f]{32}/)
	validates_format_of(:phone, with: /\+852-\d{8}|\+(?!852-)\d{2,4}-\d{,11}/)
	validates_length_of(:username, minimum: 5)
	validates_length_of(:specify_addresses, maximum: 6)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, except: [:password, :enable, :workplace_id, :workplace_type], include: :specify_addresses, method: :type))
	end
	# @return [FalseClass]
	def can_destroy
		false
	end
	# @param [Array<Hash>] addresses [Array<Hash{address: [String], region_id: [Integer]}>]
	# @return [self]
	def change_address(addresses)
		self.specify_addresses = []
		addresses.each { |x| specify_addresses << SpecifyAddress.find_or_create_by!(address: x[:address], region_id: x[:region_id]) }
		save!
		self
	end
	# @param [String] password
	# @return [self]
	def check_password(password)
		error('Wrong password') unless self.password == password
		self
	end
	# @param [String] username
	# @param [String] password
	# @param [String] name
	# @param [String] email
	# @param [String] phone
	# @param [Array<Hash>] addresses [Array<Hash{address: [String], region_id: [Integer]}>]
	# @param [FalseClass, TrueClass] enable
	# @return [self]
	def edit_account(username, password, name, email, phone, addresses, enable)
		transaction do
			error('username used') if self.username != username && RegisteredUser.find_by_username(username)
			self.username = username
			self.password = password
			self.name = name
			self.email = email
			self.phone = phone
			self.enable = enable
			change_address(addresses)
		end
	end
	# @param [String] password
	# @param [String] new_password
	# @param [String] name
	# @param [String] email
	# @param [String] phone
	# @param [Array<Hash>] addresses [Array<Hash{address: [String], region_id: [Integer]}>]
	# @return [self]
	def edit_profile(password, new_password, name, email, phone, addresses)
		transaction do
			check_password(password)
			self.password = new_password if new_password
			self.name = name if name
			self.email = email if email
			self.phone = phone if phone
			if addresses
				change_address(addresses)
			else
				save!
				self
			end
		end
	end

	class << self
		# @param [String] username
		# @param [String] phone
		# @return [self]
		def find_user_info(username, phone)
			user = find_by_username(username)
			error('User not found') unless user && user.phone == phone
			user
		end
		# @param [String] username
		# @param [String] password
		# @return [self]
		def login(username, password)
			user = find_by_username(username)
			error('Username not exist') unless user
			user.check_password(password)
			error('Account frozen') unless user.enable
			user
		end
	end

end
