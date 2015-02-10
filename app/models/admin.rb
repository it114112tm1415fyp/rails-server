class Admin < Staff
	def can_destroy
		false
	end

	class << self
		def try_login(username, password)
			admin = find_by_username(username)
			return unless admin
			admin.check_password(password)
		end
		def login(username, password)
			admin = find_by_username(username)
			error('Username not exist') unless admin
			admin.check_password(password)
		end
	end

end
