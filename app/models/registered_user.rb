class RegisteredUser < ActiveRecord::Base
	has_many(:specify_address_user_ships, as: :user)
	has_many(:specify_addresses, through: :specify_address_user_ships)
	has_many(:receive_orders, class: Order, as: :receiver)
	has_many(:send_orders, class: Order, foreign_key: :sender_id)
	validates_format_of(:email, with: /("[^"]+?"|[\da-z]|[\da-z](\.?[\w\$\*\+\-\/\?\^\{\|\}!#%&'=`~]+)*[\da-z])@(\[((0|[1-9]\d?|1\d\d|2[0-4]\d|25[0-5])\.){3}(0|[1-9]\d?|1\d\d|2[0-4]\d|25[0-5])\]|(([\da-z]|[\da-z][\w\-]*[\da-z])\.)+[\da-z]{2,24})/i)
	validates_format_of(:password, with: /[\da-f]{32}/)
	validates_format_of(:phone, with: /\+852-\d{8}|\+(?!852-)\d{2,4}-\d{,11}/)
	validates_length_of(:username, minimum: 5)
	validates_length_of(:specify_addresses, maximum: 6)
	def can_destroy
		false
	end
	#@return [RegisteredUser]
	def change_address(addresses)
		self.specify_addresses = []
		addresses.each { |x| specify_addresses << SpecifyAddress.find_or_create_by!(address: x[:address], region_id: x[:region]) }
		save!
		self
	end
	def check_password(password)
		error('Wrong password') unless self.password == password
		self
	end
	def edit_account(username, password, name, email, phone, addresses, freeze)
		transaction do
			error('username used') if self.username != username && RegisteredUser.find_by_username(username)
			self.username = username
			self.password = password
			self.name = name
			self.email = email
			self.phone = phone
			self.is_freeze = freeze
			change_address(addresses)
		end
	end
	#@return [RegisteredUser]
	def edit_profile(hash={})
		transaction do
			check_password(hash[:password])
			self.password = hash[:new_password] if hash[:new_password]
			self.name = hash[:name] if hash[:name]
			self.email = hash[:email] if hash[:email]
			self.phone = hash[:phone] if hash[:phone]
			if hash[:addresses]
				change_address(hash[:addresses])
			else
				save!
				self
			end
		end
	end
	def get_receive_orders
		receive_orders.collect { |x1| {id: x1.id, sender: x1.sender.name, departure: x1.departure.display_name, destination: x1.destination.display_name, goods: x1.goods.collect { |x2| x2.id }, staff: x1.staff.name, update_time: x1.updated_at, order_time: x1.created_at} }
	end
	def get_send_orders
		send_orders.collect { |x1| {id: x1.id, receiver: x1.receiver.name, departure: x1.departure.display_name, destination: x1.destination.display_name, goods: x1.goods.collect { |x2| x2.id }, staff: x1.staff.name, update_time: x1.updated_at, order_time: x1.created_at} }
	end

	class << self
		def find_user_info(username, phone)
			user = find_by_username(username)
			error('User not found') unless user && user.phone == phone
			{id: user.id, name: user.name, address: user.specify_addresses.collect { |x| x.display_name }}
		end
		#@return [RegisteredUser]
		def login(username, password)
			user = find_by_username(username)
			error('Username not exist') unless user
			user.check_password(password)
			error('Account frozen') if user.is_freeze
			user
		end
	end

end
