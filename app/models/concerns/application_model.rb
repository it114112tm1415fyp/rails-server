module ApplicationModel

	class Success

		def initialize(hash={})
			@detail = hash
		end

		def detail
			@detail
		end

	end

	class Error

		def initialize(error, hash={})
			@error = error
			@detail = hash
		end

		def detail
			@detail
		end

		def error
			@error
		end

	end

end

def success(*arg)
	ApplicationModel::Success.new(*arg)
end

def error(*arg)
	ApplicationModel::Error.new(*arg)
end
