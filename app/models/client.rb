class Client < RegisteredUser
	has_many(:specify_addresses_user_ships, as: :user)
	has_many(:specify_addresses, through: :specify_addresses_user_ships)

	class << self
		def login(username, password)
			client = find_by_username(username)
			error('username not exist') unless client
			client.check_password(password)
			error('account frozen') if client.is_freeze
			client
		end
		def register(username, password, name, email, phone, addresses)
			ActiveRecord::Base.transaction do
				error('username used') if find_by_username(username)
				client = create!(username: username, password: password, is_freeze: 0, name: name, email: email, phone: phone)
				change_address(client, addresses)
			end
		end
	end

end
