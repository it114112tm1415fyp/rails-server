class SpecifyAddressUserShip < ActiveRecord::Base
	belongs_to(:specify_address)
	belongs_to(:user, polymorphic: true)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Options.new(options, {only: [], include: [:specify_address, :user]}))
	end
end
