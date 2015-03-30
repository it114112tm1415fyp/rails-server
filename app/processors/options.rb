class Options < Hash
	# @param [Hash] options
	# @param [Hash] default
	def initialize(options, default)
		options.each { |x1, x2| self[x1] = x2 }
		default.each do |x1, x2|
			if has_key?(x1)
				if self[x1].is_a?(Array) && x2.is_a?(Array)
					self[x1] += x2
					self[x1].uniq!
				elsif self[x1].is_a?(Array) && x2.is_a?(Symbol)
					self[x1] += [x2]
					self[x1].uniq!
				elsif self[x1].is_a?(Symbol) && x2.is_a?(Array)
					self[x1] = [self[x1]] + x2
					self[x1].uniq!
				elsif self[x1].is_a?(Symbol) && x2.is_a?(Symbol)
					self[x1] = [self[x1], x2]
				else
					raise(ArgumentError)
				end
			else
				self[x1] = x2
			end
			self[x1] = self[x1][0] if self[x1].is_a?(Array) && self[x1].size == 1
		end
	end
end
