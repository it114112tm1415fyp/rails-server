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
		addresses.each { |x| specify_addresses << SpecifyAddress.find_or_create_by!(address: x[:address], region_id: x[:region_id]) }
		save!
		self
	end
	def check_password(password)
		error('Wrong password') unless self.password == password
		self
	end
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
	#@return [RegisteredUser]
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
	def get_receive_orders
		receive_orders.collect { |x1| {id: x1.id, sender: {id: x1.sender.id, name: x1.sender.name}, receiver: {id: x1.receiver.id, name: x1.receiver.name}, departure: {type: x1.departure.class.to_s, id: x1.departure.id, short_name: x1.departure.short_name, long_name: x1.departure.long_name, region: {id: x1.departure.region.id, name: x1.departure.region.name}}, destination: {type: order.destination.class.to_s, id: x1.destination.id, short_name: x1.destination.short_name, long_name: x1.destination.long_name, region: {id: x1.destination.region.id, name: x1.destination.region.name}}, goods_number: x1.goods_number, goods: x1.goods.collect { |x2| x2.string_id }, state: x1.order_state.name, update_time: x1.updated_at, order_time: x1.created_at} }
	end
	def get_send_orders
		send_orders.collect { |x1| {id: x1.id, sender: {id: x1.sender.id, name: x1.sender.name}, receiver: {id: x1.receiver.id, name: x1.receiver.name}, departure: {type: x1.departure.class.to_s, id: x1.departure.id, short_name: x1.departure.short_name, long_name: x1.departure.long_name, region: {id: x1.departure.region.id, name: x1.departure.region.name}}, destination: {type: order.destination.class.to_s, id: x1.destination.id, short_name: x1.destination.short_name, long_name: x1.destination.long_name, region: {id: x1.destination.region.id, name: x1.destination.region.name}}, goods_number: x1.goods_number, goods: x1.goods.collect { |x2| x2.string_id }, state: x1.order_state.name, update_time: x1.updated_at, order_time: x1.created_at} }
	end

	class << self
		def find_user_info(username, phone)
			user = find_by_username(username)
			error('User not found') unless user && user.phone == phone
			{id: user.id, name: user.name, address: user.specify_addresses.collect { |x| {id: x.id, address: x.address, region: {id: x.region.id, name: x.region.name}} }}
		end
		#@return [RegisteredUser]
		def login(username, password)
			user = find_by_username(username)
			error('Username not exist') unless user
			user.check_password(password)
			error('Account frozen') unless user.enable
			user
		end
	end

end
