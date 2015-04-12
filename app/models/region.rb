class Region < ActiveRecord::Base
	has_many(:shops)
	has_many(:specify_addresses)
	belongs_to(:store)
	after_save { Goods.non_sent.each(&:update_next_stop) }
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, only: [:id, :name]))
	end
	# @return [FalseClass, TrueClass]
	def can_destroy
		(shops + specify_addresses).size == 0
	end

	class << self
		# @return [Hash]
		def get_map
			map = {}
			find_each do |x|
				map[x.id.to_s] = x.name
			end
			map
		end
	end

end
