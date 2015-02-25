class Admin < RegisteredUser
	def can_destroy
		false
	end

	class << self
		def login(username, password)
			admin = find_by_username(username)
			error('Username not exist') unless admin
			admin.check_password(password)
		end
	end

end
