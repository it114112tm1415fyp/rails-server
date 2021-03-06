module ActiveModel::Serialization
	# @param [Hash] options
	# @return [Hash, Object]
	def serializable_hash(options = nil)
		options ||= {}
		attribute_names = attributes.keys
		result = {}
		if collect = options[:collect]
			if collect.is_a?(Symbol)
				result = send(collect)
				recursive(result, {}, options[:recursive])
			elsif collect.is_a?(Hash)
				raise(ArgumentError, 'collect') unless collect.size == 1
				collect_option = collect.values.first
				result = send(collect.keys.first, *collect_option[:parameter])
				result = recursive(result, collect_option, options[:recursive])
			else
				raise(TypeError, 'collect')
			end
			return result unless result.is_a?(Hash)
		end
		if only = options[:only]
			attribute_names &= Array(only).collect(&:to_s)
		elsif except = options[:except]
			attribute_names -= Array(except).collect(&:to_s)
		end
		attribute_names.each { |x| result[x] = read_attribute_for_serialization(x) }
		handler = Proc.new do |x1, x2, x3|
			if x2.respond_to?(:to_ary)
				result[x1.to_s] = x2.to_ary.collect { |x4| recursive(x4, x3, options[:recursive]) }
			else
				result[x1.to_s] = recursive(x2, x3, options[:recursive])
			end
		end
		serializable_add_methods(options, &handler)
		serializable_add_includes(options, &handler)
		if rename = options[:rename]
			rename.each { |x1, x2| rename_attribute(result, x1, x2) }
		end
		if remove = options[:remove]
			Array(remove).each { |x1| remove_attribute(result, x1) }
		end
		result
	end
	private
	# @param [Hash] options
	# @param [Proc(Symbol, Object, Hash)] block
	# @return [Meaningless]
	def serializable_add_methods(options={})
		return unless method = options[:method]
		method = Hash[Array(method).collect { |x| x.is_a?(Hash) ? x.to_a.first : [x, {}] }] unless method.is_a?(Hash)
		method.each do |x1, x2|
			raise(TypeError, x1.to_s) unless x2.is_a?(Hash)
			raise(TypeError, 'parameter') unless x2[:parameter].nil? || x2[:parameter].is_a?(Array)
			yield x1, send(x1, *Array(x2[:parameter])), x2 unless Array(x2[:skip]).include?(:if_not_exist) && !respond_to?(x1)
		end
	end
	# @param [Object] value
	# @param [Hash] options
	# @param [Hash] recursive_options
	# @return [Hash, Object]
	def recursive(value, options, recursive_options)
		if recursive_options && value.respond_to?(:as_json)
			value.as_json(Option.new(options, recursive_options, recursive_options))
		elsif value.respond_to?(:serializable_hash)
			value.serializable_hash(options)
		else
			value
		end
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
	# @param [Hash] result
	# @param [String, Symbol] attribute
	# @return [Hash]
	def remove_attribute(result, attribute)
		if result.is_a?(Hash)
			result.delete(attribute.to_s)
		end
		result
	end
end
