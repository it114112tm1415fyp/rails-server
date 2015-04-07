module ActiveModel::Serialization
	# @param [Hash] options
	# @return [Hash, Object]
	def serializable_hash(options = nil)
		options ||= {}
		attribute_names = attributes.keys
		if collect = options[:collect]
			return send(*Array(collect))
		elsif only = options[:only]
			attribute_names &= Array(only).collect(&:to_s)
		elsif except = options[:except]
			attribute_names -= Array(except).collect(&:to_s)
		end
		hash = {}
		attribute_names.each { |x| hash[x] = read_attribute_for_serialization(x) }
		handler = ->(x1, x2, x3) do
			if x2.respond_to?(:to_ary)
				hash[x1.to_s] = x2.to_ary.collect { |x4| recursive(x4, x3, options[:recursive]) }
			else
				hash[x1.to_s] = recursive(x2, x3, options[:recursive])
			end
		end
		serializable_add_methods(options, &handler)
		serializable_add_includes(options, &handler)
		if rename = options[:rename]
			rename.each { |x1, x2| rename_attribute(hash, x1, x2) }
		end
		hash
	end
	# @param [Hash] result
	# @param [String, Symbol] old_name
	# @param [String, Symbol] new_name
	# @return [Hash]
	def rename_attribute(result, old_name, new_name)
		if result.is_a?(Hash)
			old_name = old_name.to_s
			new_name = new_name.to_s
			result[new_name] = result.delete(old_name) if result.has_key?(old_name)
		end
		result
	end
	private
	# @param [Proc(String)] block
	def serializable_add_methods(options={})
		return unless method = options[:method]
		method = Hash[Array(method).collect { |x| x.is_a?(Hash) ? x.to_a.first : [x, {}] }] unless method.is_a?(Hash)
		method.each do |x1, x2|
			raise(ArgumentError, x1.to_s) unless x2.is_a?(Hash)
			raise(ArgumentError, 'parameter') unless x2[:parameter].nil? || x2[:parameter].is_a?(Array)
			if result = send(x1, *Array(x2[:parameter]))
				yield x1, result, x2
			end
		end
	end
	# @param [Object] value
	# @param [Hash] options
	# @param [Hash] recursive_options
	# @return [Hash, Object]
	def recursive(value, options, recursive_options)
		if recursive_options && value.respond_to?(:as_json)
			value.as_json(Option.new(recursive_options, options))
		elsif value.respond_to?(:serializable_hash)
			value.serializable_hash(options)
		else
			value
		end
	end
end
