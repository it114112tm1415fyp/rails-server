class CheckLog < ActiveRecord::Base
	belongs_to(:check_action)
	belongs_to(:goods)
	belongs_to(:staff)
	belongs_to(:location, polymorphic: true)
	before_validation { self.time = Time.current }
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, except: [:check_action_id, :location_id, :location_type], include: [:check_action, :location]))
	end
end
