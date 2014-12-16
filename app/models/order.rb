class Order < ActiveRecord::Base
	belongs_to(:departure, polymorphic: true)
	belongs_to(:destination, polymorphic: true)
	belongs_to(:receiver, polymorphic: true)
	belongs_to(:sender, class_name: 'RegisteredUser', foreign_key: :sender_id)
	belongs_to(:staff, class_name: 'Staff', foreign_key: :staff_id)
	@receive = CheckAction.find_by_name('receive')

	class << self
		def make(sender_id, receiver, staff, pay_from_receiver, goods, departure_id, departure_type, destination_id, destination_type)
			p departure_type
			raise(ParameterError, 'departure_type') unless ['ShopAddress', 'SpecifyAddress'].include?(departure_type)
			raise(ParameterError, 'destination_type') unless ['ShopAddress', 'SpecifyAddress'].include?(destination_type)
			raise(ParameterError, 'receiver') unless receiver.is_a?(Hash)
			raise(ParameterError, 'goods') unless goods.is_a?(Array)
			goods.each_with_index do |value, index|
				raise(ParameterError.new("goods[#{index}]")) unless value.is_a?(Hash)
			end
			transaction do
				departure = const_get(departure_type).find(departure_id)
				destination = const_get(destination_type).find(destination_id)
				if receiver.has_key?(:id)
					receiver = RegisteredUser.find(receiver[:id])
				else
					receiver = PublicReceiver.first_or_create!(name: receiver[:name], email: receiver[:email], phone: receiver[:phone])
				end
				order = create!(sender_id: sender_id, receiver: receiver, departure: departure, destination: destination, staff: staff, pay_from_receiver: pay_from_receiver)
				goods.collect! do |x|
					good = Good.create!(order: order, location: departure, last_action: @receive, rfid_tag: x[:rfid_tag], weight: x[:weight], fragile: x[:fragile], flammable: x[:flammable])
					CheckLog.create!(good: good, location: departure, check_action: @receive, staff: staff)
					result = {}
					result[:id] = good.id
					result[:qr_content] = 'it114112tm1415fyp' + ActiveSupport::JSON.encode({good_id: good.id, order_id: order.id, departure: departure.display_name, destination: destination.display_name, rfid_tag: good.rfid_tag, weight: good.weight, fragile: good.fragile, flammable: good.flammable, order_time: good.created_at})
					result
				end
				{order: order.id, goods: goods}
			end
		end
	end

end
