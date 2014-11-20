class RegisteredUser < ActiveRecord::Base
	validates_format_of(:email, with: /("[^"]+?"|[\da-z]|[\da-z](\.?[\w\$\*\+\-\/\?\^\{\|\}!#%&'=`~]+)*[\da-z])@(\[((0|[1-9]\d?|1\d\d|2[0-4]\d|25[0-5])\.){3}(0|[1-9]\d?|1\d\d|2[0-4]\d|25[0-5])\]|(([\da-z]|[\da-z][\w\-]*[\da-z])\.)+[\da-z]{2,24})/i)
	validates_format_of(:password, with: /[\da-f]{32}/)
	validates_format_of(:phone, with: /\+852-\d{8}|\+\d{2,4}-\d{,11}/)
	validates_format_of(:username, without: /admin/)
	validates_length_of(:username, minimum: 5)
	def check_password(password)
		error('wrong password') unless self.password == password
	end
	def edit_profile(hash={})
		ActiveRecord::Base.transaction do
			check_password(hash[:password])
			self.password = hash[:new_password] if hash[:new_password]
			self.name = hash[:name] if hash[:name]
			self.email = hash[:email] if hash[:email]
			self.phone = hash[:phone] if hash[:phone]
			if hash[:addresses]
				change_address(self, hash[:addresses])
			else
				save!
				self
			end
		end
	end

	class << self
		def change_address(client, addresses)
			client.specify_addresses = []
			addresses = ActiveSupport::JSON.decode(addresses)
			raise(ParameterError) unless addresses.size > 0 and addresses.size <= 6
			addresses.each { |address| client.specify_addresses << SpecifyAddress.find_or_create_by!(address: address) }
			client.save!
			client
		end
	end

end
