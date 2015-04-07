module Kernel
	# @param [Array(String, Hash)] arg
	# @return [Meaningless]
	def error(*arg)
		raise(Error.new(*arg))
	end
end
