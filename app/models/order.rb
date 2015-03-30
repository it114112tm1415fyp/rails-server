class Order < ActiveRecord::Base
	belongs_to(:departure, polymorphic: true)
	belongs_to(:destination, polymorphic: true)
	belongs_to(:order_state)
	belongs_to(:receiver, polymorphic: true)
	belongs_to(:sender, class: RegisteredUser, foreign_key: :sender_id)
	belongs_to(:staff)
	has_many(:free_times)
	has_many(:goods)
	validates_numericality_of(:goods_number, greater_than_or_equal_to: 1)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Options.new(options, {only: [:id, :goods_number, :created_at, :updated_at], include: [:sender, :receiver, :departure, :destination, :staff, :order_state]}))
	end
	# @return [FalseClass, TrueClass]
	def can_edit
		[OrderState.confirmed, OrderState.submitted].include?(order_state)
	end
	# @param [Staff] staff
	def cancel(staff)
		if self.order_state == OrderState.submitted || staff
			self.order_state = OrderState.canceled
			save!
		else
			error('cannot cancel order after contact, please contact staff to cancel this order')
		end
	end
	# @param [String] sender_sign
	def confirm(sender_sign)
		self.sender_sign = sender_sign
		self.order_state = OrderState.sending
		save!
	end
	def contact
		self.order_state = OrderState.after_contact if order_state == OrderState.submitted
		save!
	end
	# @param [Hash] receiver [Hash{id: [Integer]},Hash{name: [String], email: [String], phone: [String]}]
	# @param [Integer] goods_number
	# @param [Integer] departure_id
	# @param [String] departure_type
	# @param [Integer] destination_id
	# @param [String] destination_type
	# @param [Staff] staff
	def edit(receiver, goods_number, departure_id, departure_type, destination_id, destination_type, staff)
		raise(ParameterError, 'departure_type') if departure_type && ![Shop.to_s, SpecifyAddress.to_s].include?(departure_type)
		raise(ParameterError, 'destination_type') if departure_type && ![Shop.to_s, SpecifyAddress.to_s].include?(departure_type)
		raise(ParameterError, 'receiver') if receiver && !receiver.is_a?(Hash)
		if receiver
			if receiver.has_key?(:id)
				self.receiver = RegisteredUser.find(receiver[:id])
			else
				self.receiver = PublicReceiver.find_or_create_by!(name: receiver[:name], email: receiver[:email], phone: receiver[:phone])
			end
		end
		self.goods_number = goods_number if goods_number
		if departure_id && departure_type
			if self.order_state == OrderState.submitted || staff
				self.departure = Object.const_get(departure_type).find(departure_id)
				goods.each do |x|
					x.location = departure
					x.save!
				end
			else
				error('cannot edit order departure after contact, please contact staff to do this change')
			end
		end
		self.destination = Object.const_get(destination_type).find(destination_id) if destination_id && destination_type
		error('departure do not match sender address') if departure.is_a?(SpecifyAddress) && !sender.specify_addresses.include?(departure) && !staff
		error('destination do not match receive address') if destination.is_a?(SpecifyAddress) && receiver.is_a?(RegisteredUser) && !receiver.specify_addresses.include?(destination)
		save!
	end

	class << self
		# @param [Integer] order_id
		# @return [Hash]
		def get_details(order_id)
			order = find(order_id)
			{sender: {id: order.sender_id, name: order.sender.name}, receiver: {id: order.receiver.id, name: order.receiver.name}, departure: {type: order.departure_type, id: order.departure.id, short_name: order.departure.short_name, long_name: order.departure.long_name, region: {id: order.departure.region.id, name: order.departure.region.name}}, destination: {type: order.destination_type, id: order.destination.id, address: order.destination.address, region: {id: order.destination.region.id, name: order.destination.region.name}}, goods_number: order.goods_number, goods: order.goods.collect(&:string_id), state: order.order_state.name, update_time: order.updated_at, order_time: order.created_at}
		end
		# @param [RegisteredUser] sender
		# @param [Hash] receiver [Hash{id: [Integer]},Hash{name: [String], email: [String], phone: [String]}]
		# @param [Integer] goods_number
		# @param [Integer] departure_id
		# @param [String] departure_type
		# @param [Integer] destination_id
		# @param [String] destination_type
		# @param [Array<FalseClass, TrueClass>] time
		# @return [Hash]
		def make(sender, receiver, goods_number, departure_id, departure_type, destination_id, destination_type, time)
			raise(ParameterError, 'departure_type') unless [Shop.to_s, SpecifyAddress.to_s].include?(departure_type)
			raise(ParameterError, 'destination_type') unless [Shop.to_s, SpecifyAddress.to_s].include?(destination_type)
			raise(ParameterError, 'receiver') unless receiver.is_a?(Hash)
			transaction do
				departure = const_get(departure_type).find(departure_id)
				destination = const_get(destination_type).find(destination_id)
				if receiver.has_key?(:id)
					receiver = RegisteredUser.find(receiver[:id])
				else
					receiver = PublicReceiver.find_or_create_by!(name: receiver[:name], email: receiver[:email], phone: receiver[:phone])
				end
				error('departure do not match sender address') if departure.is_a?(SpecifyAddress) && !sender.specify_addresses.include?(departure)
				error('destination do not match receive address') if destination.is_a?(SpecifyAddress) && receiver.is_a?(RegisteredUser) && !receiver.specify_addresses.include?(destination)
				order = create!(sender: sender, receiver: receiver, departure: departure, destination: destination, goods_number: goods_number, order_state: OrderState.submitted)
				{id: order.id}
			end
		end
	end

end
