class Admin < RegisteredUser
	# @return [FalseClass]
	def can_destroy
		false
	end

	class << self
		# @return [RegisteredUser]
		def login(username, password)
			admin = find_by_username(username)
			error('Username not exist') unless admin
			admin.check_password(password)
		end
	end

end
