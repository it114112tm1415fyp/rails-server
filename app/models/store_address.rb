class StoreAddress < ActiveRecord::Base
	has_many(:check_logs, as: :location)
	has_many(:conveyors)
	has_many(:goods, as: :location)
	validates_numericality_of(:size, greater_than: 0)
	def display_name
		address
	end
end
