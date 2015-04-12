class ReceiveTimeSegment < ActiveRecord::Base
	scope(:enabled, Proc.new { where(enable: true).order(:start_time) })
	after_save { SchemeVersion.update_version(self.class) }
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, except: [:id, :enable]))
	end
end
