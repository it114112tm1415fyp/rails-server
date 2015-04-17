class Order < ActiveRecord::Base
	FREE_TIME_DAYS = 7
	belongs_to(:departure, polymorphic: true)
	belongs_to(:destination, polymorphic: true)
	belongs_to(:order_state)
	belongs_to(:receiver, polymorphic: true)
	belongs_to(:sender, class_name: RegisteredUser, foreign_key: :sender_id)
	belongs_to(:staff)
	has_many(:free_times)
	has_many(:goods, class_name: Goods)
	has_one(:queue, class_name: OrderQueue)
	scope(:sending, Proc.new { where(order_state: OrderState.sending) })
	scope(:submitted, Proc.new { where(order_state: OrderState.submitted) })
	validates_numericality_of(:goods_number, greater_than_or_equal_to: 1)
	before_validation { self.receive_time_version = SchemeVersion[ReceiveTimeSegment].scheme_update_time }
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, only: [:id, :goods_number, :created_at, :updated_at], include: [:sender, :receiver, :departure, :destination, :staff, :order_state, { goods: { collect: :string_id, merge_type: :replace } }], rename: { goods: :goods_ids }))
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
			transaction do
				self.order_state = OrderState.canceled
				queue.destroy if queue
				save!
			end
		else
			error('cannot cancel order after contact, please contact staff to cancel this order')
		end
	end
	# @param [Integer] task_id
	# @param [String] sign
	# @return [Meaningless]
	def confirm(task_id, sign)
		task_worker = TaskWorker.find(task_id)
		raise(ArgumentError) if goods.empty?
		case order_state
			when OrderState.confirmed
				raise(ArgumentError) unless task_worker.check_action == CheckAction.receive
				self.sender_sign = sign
				self.order_state = OrderState.sending
			when OrderState.sending
				raise(ArgumentError) unless task_worker.check_action == CheckAction.issue
				self.receiver_sign = sign
				self.order_state = OrderState.sent
			else
				raise(ArgumentError)
		end
		VisitTaskOrder.create!(visit_task: task_worker.task, order: self)
		task_worker.task.check_received if task_worker.check_action == CheckAction.receive
		save!
	end
	# @return [Meaningless]
	def contact
		self.order_state = OrderState.confirmed if order_state == OrderState.submitted
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
		raise(ParameterError, 'departure_type') if departure_type && ![Shop.name, SpecifyAddress.name].include?(departure_type)
		raise(ParameterError, 'destination_type') if departure_type && ![Shop.name, SpecifyAddress.name].include?(departure_type)
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
		FreeTime.joins(:receive_time_segment).where(order: self, date: today..today + FREE_TIME_DAYS.days).order(date: :asc).order("`#{:receive_time_segments}`.`#{:start_time}` ASC")
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
		def make(sender, receiver, goods_number, departure_id, departure_type, destination_id, destination_type, time=[])
			raise(ParameterError, 'departure_type') unless [Shop.name, SpecifyAddress.name].include?(departure_type)
			raise(ParameterError, 'destination_type') unless [Shop.name, SpecifyAddress.name].include?(destination_type)
			raise(ParameterError, 'receiver') unless receiver.is_a?(Hash)
			transaction do
				departure = const_get(departure_type).find(departure_id)
				destination = const_get(destination_type).find(destination_id)
				if receiver.has_key?(:id)
					receiver = RegisteredUser.find(receiver[:id])
				else
					receiver = PublicReceiver.find_or_create_by!(name: receiver[:name], email: receiver[:email], phone: receiver[:phone])
					if destination.is_a?(SpecifyAddress)
						receiver.specify_addresses << destination
						receiver.specify_addresses.uniq!
						receiver.save!
					end
				end
				error('departure do not match sender address') if departure.is_a?(SpecifyAddress) && !sender.specify_addresses.include?(departure)
				error('destination do not match receive address') if destination.is_a?(SpecifyAddress) && receiver.is_a?(RegisteredUser) && !receiver.specify_addresses.include?(destination)
				order = create!(sender: sender, receiver: receiver, departure: departure, destination: destination, goods_number: goods_number, order_state: OrderState.submitted)
				order.change_time(time) if departure_type == SpecifyAddress.name
				OrderQueue.create!(order: order, queue_times: 1, receive: true) if departure.is_a?(SpecifyAddress)
				order
			end
		end
		# @param [Store] store
		# @param [Integer] limit
		# @return [Array<Order>]
		def ready_to_issue(store, limit)
			sending.where(destination_type: SpecifyAddress).joins(:goods).where(goods: { location: store }).order(:id).find_all { |x| x.destination.region.store == store }.first(limit)
		end
		# @param [Store] store
		# @param [Integer] limit
		# @return [Array<Order>]
		def ready_to_receive(store, limit)
			submitted.where(departure_type: SpecifyAddress).order(:id).find_all { |x| x.departure.region.store == store }.first(limit)
		end
	end

end
