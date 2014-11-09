class Conveyor < ActiveRecord::Base
	belongs_to(:address)
	validates_numericality_of(:server_port, greater_than_or_equal_to: 0, less_than: 65536)
end
