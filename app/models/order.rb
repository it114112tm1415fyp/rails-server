class Order < ActiveRecord::Base
	belongs_to(:receiver, polymorphic: true)
	belongs_to(:sender, class_name: 'RegisteredUser', foreign_key: :sender_id)
	belongs_to(:staff, class_name: 'Staff', foreign_key: :staff_id)
	@check_action = CheckAction.find_by_name('receive')

	class << self
		def make(sender_id, receiver, staff, pay_from_receiver, goods, location_id, location_type)
			raise(ParameterError, 'location_type') unless ['ShopAddress', 'SpecifyAddress'].include?(location_type)
			raise(ParameterError, 'receiver') unless receiver.is_a?(Hash)
			raise(ParameterError, 'goods') unless goods.is_a?(Array)
			goods.each_with_index do |value, index|
				raise(ParameterError.new("goods[#{index}]")) unless value.is_a?(Hash)
			end
			transaction do
				location = const_get(location_type).find(location_id)
				if receiver.has_key?(:id)
					receiver = RegisteredUser.find(receiver[:id])
				else
					receiver = PublicReceiver.first_or_create!(name: receiver[:name], email: receiver[:email], phone: receiver[:phone])
				end
				order = create!(sender_id: sender_id, receiver: receiver, staff: staff, pay_from_receiver: pay_from_receiver)
				goods.collect! do |x|
					good = Good.create!(order: order, location: location, rfid_tag: x[:rfid_tag], weight: x[:weight], fragile: x[:fragile], flammable: x[:flammable])
					CheckLog.create!(good: good, stakeholder: location, check_action: @check_action, staff: staff)
					good.id
				end
				{order: order.id, goods: goods}
			end
		end
	end

end
