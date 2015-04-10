class Order < ActiveRecord::Base
	FREE_TIME_DAYS = 7
	belongs_to(:departure, polymorphic: true)
	belongs_to(:destination, polymorphic: true)
	belongs_to(:order_state)
	belongs_to(:receiver, polymorphic: true)
	belongs_to(:sender, class: RegisteredUser, foreign_key: :sender_id)
	belongs_to(:staff)
	has_many(:free_times)
	has_many(:goods, class: Goods)
	validates_numericality_of(:goods_number, greater_than_or_equal_to: 1)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, {only: [:id, :goods_number, :created_at, :updated_at], include: [:sender, :receiver, :departure, :destination, :staff, :order_state, {goods: {collect: :string_id, marge_type: :replace}}], rename: {goods: :goods_ids}}))
	end
	# @return [FalseClass, TrueClass]
	def can_edit
		[OrderState.confirmed, OrderState.submitted].include?(order_state)
	end
	# @param [Array<FalseClass, TrueClass>] free
	# @return [Meaningless]
	def change_time(free)
		raise(ArgumentError) unless free.size == ReceiveTimeSegment.enabled.size * FREE_TIME_DAYS
		today = Date.today
		meaningful_free_times.destroy_all
		receive_time_segments = ReceiveTimeSegment.enabled
		segments_size = receive_time_segments.size
		FREE_TIME_DAYS.times do |x1|
			date = today + x1.days
			receive_time_segments.each_with_index { |x2, x3| FreeTime.create!(order: self, receive_time_segment: x2, date: date, free: free[x1 * segments_size + x3]) }
		end
	end
	# @param [Staff] staff
	# @return [Meaningless]
	def cancel(staff)
		if order_state == OrderState.submitted || staff
			self.order_state = OrderState.canceled
			save!
		else
			error('cannot cancel order after contact, please contact staff to cancel this order')
		end
	end
	# @param [String] sender_sign
	# @return [Meaningless]
	def confirm(sender_sign)
		self.sender_sign = sender_sign
		self.order_state = OrderState.sending
		save!
	end
	# @return [Meaningless]
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
	# @param [Array<FalseClass, TrueClass>] time
	# @param [Staff] staff
	# @return [Meaningless]
	def edit(receiver, goods_number, departure_id, departure_type, destination_id, destination_type, time, staff)
		raise(ParameterError, 'departure_type') if departure_type && ![Shop.to_s, SpecifyAddress.to_s].include?(departure_type)
		raise(ParameterError, 'destination_type') if departure_type && ![Shop.to_s, SpecifyAddress.to_s].include?(departure_type)
		raise(ParameterError, 'receiver') if receiver && !receiver.is_a?(Hash)
		transaction do
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
			change_time(time) if time
		end
	end
	# @return [self]
	def meaningful_free_times
		today = Date.today
		FreeTime.includes(:receive_time_segment).where(order: self, date: today..today + FREE_TIME_DAYS.days).order(date: :asc).order("#{ReceiveTimeSegment.table_name}.start_time ASC")
	end

	class << self
		# @param [RegisteredUser] sender
		# @param [Hash] receiver [Hash{id: [Integer]},Hash{name: [String], email: [String], phone: [String]}]
		# @param [Integer] goods_number
		# @param [Integer] departure_id
		# @param [String] departure_type
		# @param [Integer] destination_id
		# @param [String] destination_type
		# @param [Array<FalseClass, TrueClass>] time
		# @return [self]
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
					receiver.specify_addresses << destination
					receiver.specify_addresses.uniq!
					receiver.save!
				end
				error('departure do not match sender address') if departure.is_a?(SpecifyAddress) && !sender.specify_addresses.include?(departure)
				error('destination do not match receive address') if destination.is_a?(SpecifyAddress) && receiver.is_a?(RegisteredUser) && !receiver.specify_addresses.include?(destination)
				order = create!(sender: sender, receiver: receiver, departure: departure, destination: destination, goods_number: goods_number, order_state: OrderState.submitted)
				order.change_time(time)
			end
		end
	end

end
