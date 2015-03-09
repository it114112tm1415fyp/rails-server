class VisitTaskPlan < ActiveRecord::Base
	belongs_to(:car)
	belongs_to(:store)
	scope(:day, Proc.new { |x| where("(#{table_name}.day >> #{x}) & 1 = 1") })
	validate(:send_number_is_less_than_or_equal_to_send_receive_number)
	validates_numericality_of(:day, greater_than_or_equal_to: 0, less_than: 2 ** 7)
	validates_numericality_of(:send_number, greater_than_or_equal_to: 0)
	validates_numericality_of(:send_receive_number, greater_than: 0)
	private
	def send_number_is_less_than_or_equal_to_send_receive_number
		errors.add(:send_number, 'send_number is bigger than send_receive_number') if send_number > send_receive_number
	end
end
