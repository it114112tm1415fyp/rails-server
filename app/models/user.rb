class User < ActiveRecord::Base
	belongs_to(:user_type)
	has_many(:address_user_ships)
	has_many(:addresses, through: :address_user_ships)
	has_many(:check_logs, foreign_key: :staff_id)
	has_many(:permission_user_ships)
	has_many(:permissions, through: :permission_user_ships)
	validates_absence_of(:password, unless: proc { user_type.can_login if user_type })
	validates_absence_of(:username, unless: proc { user_type.can_login if user_type })
	validates_format_of(:email, with: /("[^"]+?"|[\da-z]|[\da-z](\.?[\w\$\*\+\-\/\?\^\{\|\}!#%&'=`~]+)*[\da-z])@(\[((0|[1-9]\d?|1\d\d|2[0-4]\d|25[0-5])\.){3}(0|[1-9]\d?|1\d\d|2[0-4]\d|25[0-5])\]|(([\da-z]|[\da-z][\w\-]*[\da-z])\.)+[\da-z]{2,24})/i)
	validates_format_of(:password, with: /[\da-f]{32}/, if: proc { user_type.can_login if user_type })
	validates_format_of(:phone, with: /\+852-\d{8}|\+\d{2,4}-\d{,11}/)
	validates_length_of(:username, minimum: 5, if: proc { user_type.can_login if user_type })
	validates_uniqueness_of(:user_type_id, if: proc { user_type.is_unique if user_type })
	class << self
		def check_password(user, password)
			error('wrong password') unless user.password == password
		end
		def edit_profile(user, hash={})
			ActiveRecord::Base.transaction do
				User.check_password(user, hash[:password])
				user.password = hash[:new_password] if hash[:new_password]
				user.name = hash[:name] if hash[:name]
				user.email = hash[:email] if hash[:email]
				user.phone = hash[:phone] if hash[:phone]
				if hash[:addresses]
					change_address(user, hash[:addresses])
				else
					user.save!
					user
				end
			end
		end
		def customer_login(username, password)
			user = find_by_username(username)
			error('username not exist') unless user
			check_password(user, password)
			error('account frozen') if user.is_freeze
			user
		end
		def customer_register(username, password, name, email, phone, addresses)
			ActiveRecord::Base.transaction do
				error('username used') if find_by_username(username)
				user = create!(username: username, password: password, is_freeze: 0, name: name, email: email, phone: phone, user_type: UserType.find_by_name('client'))
				change_address(user, addresses)
			end
		end
		private
		def change_address(user, addresses)
			user.addresses = []
			addresses = ActiveSupport::JSON.decode(addresses)
			raise(ParameterError) unless addresses.size > 0 and addresses.size <= 6
			addresses.each { |address| user.addresses << Address.find_or_create_by!(address: address, address_type: AddressType.find_by_name('specify')) }
			user.save!
			user
		end
	end
end
