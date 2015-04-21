class CheckAction < ActiveRecord::Base
	has_many(:check_logs)
	has_many(:goods, class_name: Goods)
	# @param [Hash] options
	# @return [String]
	def as_json(options={})
		super(Option.new(options, collect: :name))
	end
	# @param [self] check_action
	# @return [FalseClass, TrueClass]
	def can_done_after(check_action)
		not_implemented
	end
	# @param [Goods] goods
	# @param [LogisticTask] task
	# @param [Hash] addition
	# @return [Meaningless]
	def edit_goods(goods, task_worker, addition)
		change_goods_last_action(goods)
		CheckAction.send(name).edit_goods_for_action(goods, task_worker.task, addition)
		goods.staff = task_worker.staff
		goods.save!
	end
	# @param [Goods] goods
	# @param [LogisticTask] task
	# @param [Hash] addition
	# @return [Meaningless]
	def edit_goods_for_action(goods, task, addition)
		not_implemented
	end
	# @param [Goods] goods
	# @return [Meaningless]
	def change_goods_last_action(goods)
		if CheckAction.send(name).can_done_after(goods.last_action)
			goods.last_action = self
		else
			error('state not match.')
		end
	end
	class << self
		# @return [self]
		def contact
			@contact ||= find_by_name!('contact')
		end
		# @return [self]
		def inspect
			unless @inspect
				@inspect = find_by_name!('inspect')
				class << @inspect
					# @param [self] check_action
					# @return [FalseClass, TrueClass]
					def can_done_after(check_action)
						check_action == CheckAction.inspect || check_action == CheckAction.warehouse
					end
					# @param [Goods] goods
					# @param [LogisticTask] task
					# @param [Hash] addition
					# @return [Meaningless]
					def edit_goods_for_action(goods, task, addition)
						case task
							when InspectTask
							else
								raise(ArgumentError)
						end
					end
				end
			end
			@inspect
		end
		# @return [self]
		def issue
			unless @issue
				@issue = find_by_name!('issue')
				class << @issue
					# @param [self] check_action
					# @return [FalseClass, TrueClass]
					def can_done_after(check_action)
						true
					end
					# @param [Goods] goods
					# @param [LogisticTask] task
					# @param [Hash] addition
					# @return [Meaningless]
					def edit_goods_for_action(goods, task, addition)
						case task
							when IssueTask, ServeTask
								goods.location = goods.order.destination
								goods.next_stop = goods.location
							else
								raise(ArgumentError)
						end
					end
				end
			end
			@issue
		end
		# @return [self]
		def leave
			unless @leave
				@leave = find_by_name!('leave')
				class << @leave
					# @param [self] check_action
					# @return [FalseClass, TrueClass]
					def can_done_after(check_action)
						check_action == CheckAction.inspect || check_action == CheckAction.receive || check_action == CheckAction.warehouse
					end
					# @param [Goods] goods
					# @param [LogisticTask] task
					# @param [Hash] addition
					# @return [Meaningless]
					def edit_goods_for_action(goods, task, addition)
						case task
							when IssueTask
								goods.location = task.region.store
							when TransferTask
								goods.location = task.from
							else
								raise(ArgumentError)
						end
						goods.shelf_id = nil
					end
				end
			end
			@leave
		end
		# @return [self]
		def load
			unless @load
				@load = find_by_name!('load')
				class << @load
					# @param [self] check_action
					# @return [FalseClass, TrueClass]
					def can_done_after(check_action)
						check_action == CheckAction.leave || check_action == CheckAction.unload
					end
					# @param [Goods] goods
					# @param [LogisticTask] task
					# @param [Hash] addition
					# @return [Meaningless]
					def edit_goods_for_action(goods, task, addition)
						case task
							when IssueTask, TransferTask
								goods.location = task.car
							else
								raise(ArgumentError)
						end
					end
				end
			end
			@load
		end
		# @return [self]
		def receive
			unless @receive
				@receive = find_by_name!('receive')
				class << @receive
					# @param [self] check_action
					# @return [FalseClass, TrueClass]
					def can_done_after(check_action)
						false
					end
				end
			end
			@receive
		end
		# @return [self]
		def unload
			unless @unload
				@unload = find_by_name!('unload')
				class << @unload
					# @param [self] check_action
					# @return [FalseClass, TrueClass]
					def can_done_after(check_action)
						check_action == CheckAction.load || check_action == CheckAction.receive
					end
					# @param [Goods] goods
					# @param [LogisticTask] task
					# @param [Hash] addition
					# @return [Meaningless]
					def edit_goods_for_action(goods, task, addition)
						case task
							when ReceiveTask, TransferTask
							else
								raise(ArgumentError)
						end
					end
				end
			end
			@unload
		end
		# @return [self]
		def warehouse
			unless @warehouse
				@warehouse = find_by_name!('warehouse')
				class << @warehouse
					# @param [self] check_action
					# @return [FalseClass, TrueClass]
					def can_done_after(check_action)
						check_action == CheckAction.leave || check_action == CheckAction.unload
					end
					# @param [Goods] goods
					# @param [LogisticTask] task
					# @param [Hash] addition
					# @return [Meaningless]
					def edit_goods_for_action(goods, task, addition)
						case task
							when TransferTask
								goods.location = task.to
							when ReceiveTask
								goods.location = task.region.store
							else
								raise(ArgumentError)
						end
						goods.update_next_stop
						goods.shelf_id = addition['shelf_id'].to_i if goods.location.is_a?(Store)
					end
				end
			end
			@warehouse
		end
	end

end
