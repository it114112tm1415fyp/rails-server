class SchemeVersion < ActiveRecord::Base
	before_validation { self.scheme_update_time = Time.now }

	class << self
		# @param [Class] scheme
		# @return [self, NilClass]
		def [](scheme)
			find_or_create_by(scheme_name: scheme.name)
		end
		# @param [Class] scheme
		# @return [Meaningless]
		def update_version(scheme)
			self[scheme].save
		end
	end

end
