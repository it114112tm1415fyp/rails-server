module CustomerAccount

	include ApplicationModel

	def self.login(username, password)
		user = User.find_by_username(username)
		return error('username not exist') unless user
		return error('wrong password') unless user.password == password
		return error('account frozen') if user.is_freeze
		success
	end

	def self.register(username, password, name, email, phone, addresses)
		ActiveRecord::Base.transaction do
			addresses = ActiveSupport::JSON.decode(addresses)
			raise(Exception.new) unless addresses.size > 0 and addresses.size <= 6
			return error('username used') if User.find_by_username(username)
			user = User.create!(username: username, password: password, is_freeze: 0, name: name, email: email, phone: phone, user_type: UserType.find_by_name('client'))
			for x in addresses
				address = Address.where(address: x, address_type: AddressType.find_by_name('specify')) || Address.create!(address: x, address_type: AddressType.find_by_name('specify'))
				user.addresses << address
				user.save!
			end
			success
		end
	end

end
