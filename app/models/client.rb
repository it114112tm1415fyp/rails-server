class Client < RegisteredUser

	class << self
		#@return [RegisteredUser]
		def register(username, password, name, email, phone, addresses)
			ActiveRecord::Base.transaction do
				error('username used') if RegisteredUser.find_by_username(username)
				client = create!(username: username, password: password, name: name, email: email, phone: phone)
				client.change_address(addresses)
			end
		end
	end

end
