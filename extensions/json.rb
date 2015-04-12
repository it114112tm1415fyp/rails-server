# module ActiveModel::Serializers::JSON
# 	# @param [Hash, NilClass] options
# 	# @return [Hash]
# 	def as_json(options = nil)
# 		puts "#{self.class}.as_json".fc_n_purple.bc_n_black + "(#{options})".fc_b_purple.bc_n_black
# 		if options && options.key?(:root)
# 			root = options[:root]
# 		else
# 			root = include_root_in_json
# 		end
# 		if root
# 			root = model_name.element if root.is_a?(TrueClass)
# 			result = { root => serializable_hash(options) }
# 		else
# 			result = serializable_hash(options)
# 		end
# 		puts "#{self.class}.as_json return #{result}".fc_b_purple.bc_n_black
# 		result
# 	end
# end
