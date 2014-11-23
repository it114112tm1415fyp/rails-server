class Admin <

	class << self
		def check_password(password)
			error('wrong password') unless first.password == password
		end
		def login(password)
			check_password(password)
			first
		end
	end

end
