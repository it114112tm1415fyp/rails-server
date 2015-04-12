class Option < Hash
	OPTION_KET = [:only, :except, :include, :method, :collect, :parameter]
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
		raise(OptionMargeError, self.to_s) if has_key?(:only) && has_key?(:except)
		case recursive
			when FalseClass, Hash
				self[:recursive] = recursive
			when TrueClass
				if options.is_a?(Option)
					self[:recursive] = options[:recursive]
				else
					self[:recursive] = options.dup
					OPTION_KET.each { |x| self[:recursive].delete(x) }
				end
			else
				raise(ArgumentError, 'recursive')
		end
	end

	def normalize_recursive_options(options)
		return options[:recursive] if options.is_a?(Option)
		options = options.dup
		options.dele
	end
end
