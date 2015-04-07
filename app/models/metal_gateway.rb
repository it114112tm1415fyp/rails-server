class MetalGateway < ActiveRecord::Base
	belongs_to(:store)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, {only: [:id, :name], include: :store}))
	end
end
