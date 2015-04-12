class PublicReceiver < ActiveRecord::Base
	has_many(:orders, as: :receiver_id)
	has_many(:specify_address_user_ships, as: :user)
	has_many(:specify_addresses, through: :specify_address_user_ships)
	validates_format_of(:email, with: /("[^"]+?"|[\da-z]|[\da-z](\.?[\w\$\*\+\-\/\?\^\{\|\}!#%&'=`~]+)*[\da-z])@(\[((0|[1-9]\d?|1\d\d|2[0-4]\d|25[0-5])\.){3}(0|[1-9]\d?|1\d\d|2[0-4]\d|25[0-5])\]|(([\da-z]|[\da-z][\w\-]*[\da-z])\.)+[\da-z]{2,24})/i)
	validates_format_of(:phone, with: /\+852-\d{8}|\+(?!852-)\d{2,4}-\d{,11}/)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, include: :specify_addresses, method: :type))
	end
end
