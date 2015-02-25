class CheckAction < ActiveRecord::Base
	has_many(:check_logs)
	has_many(:goods)
	def can_done_after(check_action)
		false
	end

	class << self
		def inspect
			unless @inspect
				@inspect = find_by_name('inspect')
				class << @inspect
					def can_done_after(check_action)
						check_action == inspect || check_action == warehouse
					end
				end
			end
			@inspect
		end
		def issue
			unless @issue
				@issue = find_by_name('issue')
				class << @issue
					def can_done_after(check_action)
						check_action == unload || check_action == warehouse
					end
				end
			end
			@issue
		end
		def leave
			unless @leave
				@leave = find_by_name('leave')
				class << @leave
					def can_done_after(check_action)
						check_action == inspect || check_action == receive || check_action == warehouse
					end
				end
			end
			@leave
		end
		def load
			unless @load
				@load = find_by_name('load')
				class << @load
					def can_done_after(check_action)
						check_action == leave || check_action == receive || check_action == unload
					end
				end
			end
			@load
		end
		def receive
			@receive ||= find_by_name('receive')
		end
		def unload
			unless @unload
				@unload = find_by_name('unload')
				class << @unload
					def can_done_after(check_action)
						check_action == CheckAction.load
					end
				end
			end
			@unload
		end
		def warehouse
			unless @warehouse
				@warehouse = find_by_name('warehouse')
				class << @warehouse
					def can_done_after(check_action)
						check_action == leave || check_action == unload
					end
				end
			end
			@warehouse
		end
	end

end
