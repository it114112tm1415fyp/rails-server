class Store < ActiveRecord::Base
	has_many(:check_logs, as: :location)
	has_many(:conveyors)
	has_many(:goods, as: :location)
	has_many(:regions)
	validates_numericality_of(:size, greater_than: 0)
	def can_destroy
		(check_logs + conveyors + goods).size == 0
	end
	def display_name
		address
	end

	class << self
		def get_list
			all.collect { |x| {id: x.id, address: x.display_name, size: x.size} }
		end
	end

end
