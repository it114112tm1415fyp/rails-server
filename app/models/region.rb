class Region < ActiveRecord::Base
	has_many(:shops)
	has_many(:specify_addresses)
	belongs_to(:store)

	class << self
		def get_list
			all.collect {|x| {id: x.id, name: x.name} }
		end
		def get_map
			region_list = {}
			Region.find_each do |x|
				region_list[x.id.to_s] = x.name
			end
		end
	end

end
