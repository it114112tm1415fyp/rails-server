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

	class << self
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
						check_action == CheckAction.leave || check_action == CheckAction.receive || check_action == CheckAction.unload
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
						check_action == CheckAction.load
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
				end
			end
			@warehouse
		end
	end

end
