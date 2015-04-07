module ActiveRecord::AttributeMethods::TimeZoneConversion

	module ClassMethods
		private
		def create_time_zone_conversion_attribute?(name, cast_type)
			time_zone_aware_attributes &&
					!self.skip_time_zone_conversion_for_attributes.include?(name.to_sym) &&
							[:datetime, :time].include?(cast_type.type)
		end
	end

end
