class SpecifyAddressUserShip < ActiveRecord::Base
	belongs_to(:specify_address)
	belongs_to(:user, polymorphic: true)
end
