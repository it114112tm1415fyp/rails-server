class Error < Exception
	def initialize(error, details={})
		super(error)
		@details = details
	end
	# @return [Hash]
	def details
		@details
	end
end
