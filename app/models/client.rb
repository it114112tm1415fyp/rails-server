class Client < RegisteredUser

	class << self
		#@return [RegisteredUser]
		def register(username, password, name, email, phone, addresses)
			ActiveRecord::Base.transaction do
				error('username used') if find_by_username(username)
				client = create!(username: username, password: password, is_freeze: 0, name: name, email: email, phone: phone)
				change_address(client, addresses)
			end
		end
	end

end
