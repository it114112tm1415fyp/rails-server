class ParameterError < StandardError
	def initialize(parameter = nil)
		if parameter
			super("Invalid parameter \"#{parameter}\"")
		else
			super('There is an invalid parameter')
		end
	end
end
