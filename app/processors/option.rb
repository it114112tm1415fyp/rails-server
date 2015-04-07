class Option < Hash
	# @param [Hash] options
	# @param [Hash] default
	# @param [FalseClass, Hash, TrueClass] recursive
	def initialize(options, default, recursive=true)
		options.each { |x1, x2| self[x1] = x2 }
		marge_type = options[:marge_type] || :add
		case marge_type
			when :add
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
							raise(ArgumentError, "self[x1]: #{self[x1].class}, x2: #{x2.class}")
						end
					else
						self[x1] = x2
					end
					self[x1] = self[x1][0] if self[x1].is_a?(Array) && self[x1].size == 1
				end
			when :replace
			else
				raise(ArgumentError, 'marge_type')
		end
		raise(OptionMargeError) if has_key?(:only) && has_key?(:except)
		case recursive
			when FalseClass, Hash
				self[:recursive] = recursive
			when TrueClass
				self[:recursive] = options.is_a?(Option) ? options[:recursive] : options if recursive.is_a?(TrueClass)
			else
				raise(ArgumentError, 'recursive')
		end
	end
end
