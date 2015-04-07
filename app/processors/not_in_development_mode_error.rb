class NotInDevelopmentModeError < StandardError
	def initialize
		super('This method can only call in development mode.')
	end
end
