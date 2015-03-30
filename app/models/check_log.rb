class CheckLog < ActiveRecord::Base
	belongs_to(:check_action)
	belongs_to(:goods)
	belongs_to(:staff)
	belongs_to(:location, polymorphic: true)
	before_validation(on: :create) do
		self.time = Time.current
	end
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Options.new(options, {except: [:location_id, :location_type], include: :location}))
	end
end
