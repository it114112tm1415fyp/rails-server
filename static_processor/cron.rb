class Cron
	ATTRIBUTE = [:time, :repeat, :tag]
	PRINT_SIZE = {time: 5, repeat: 5}
	@tasks ||= []
	attr_accessor(*ATTRIBUTE)
	# @param [Symbol] tag
	# @param [CronTime] time
	# @param [FalseClass, TrueClass] repeat
	# @param [Array] parameters
	# @param [Proc] block
	def initialize(tag, time, repeat, *parameters, &block)
		raise(ArgumentError, 'tried to create Cron object without a block') unless block
		@tag = tag
		@time = time
		@repeat = repeat
		@parameters = parameters
		@action = block
	end
	# @param [CronTime] other
	def time=(other)
		@time = other
		run if @time == CronTime.now
	end
	# @return [Meaningless]
	def run
		Rails.logger.debug { "Cron run #{@tag} at #{@time.to_s}".fc_n_green }
		Cron.tasks.delete(self) unless @repeat
		begin
			@action.call(*@parameters, time)
		rescue
			Rails.logger.error { 'Cron error occurred'.fc_n_red }
			Rails.logger.error { "  #{$!.message}".fc_b_red }
			Rails.logger.error { $!.backtrace.collect { |x| "    #{x}".fc_n_red} }
		end
	end
	# @return [Meaningless]
	def destroy
		Rails.logger.info { 'Cron delete task:'.fc_n_green }
		print
		Cron.tasks.delete(self)
		Cron.show_tasks(true)
	end
	# @return [Meaningless]
	def print
		Rails.logger.info { "  #{ATTRIBUTE.collect { |x| "#{x.to_s} : ".fc_n_green + ("%-#{PRINT_SIZE[x]}s" % "#{send(x)}").fc_b_green }.join(' ')}" }
	end
	class << self
		attr_reader(:tasks)
		# @return [Meaningless]
		def start
			@thread ||= Thread.new do
				loop do
					do_task(CronTime.now)
					now = Time.now
					sleep(now.at_end_of_minute - now + 0.000001)
				end
			end
			@thread.abort_on_exception = true
		end
		# @param [Array<self>] tasks
		def add_tasks(*tasks)
			show_tasks(false)
			if tasks.empty?
				Rails.logger.info { 'Cron no task added : '.fc_n_green }
			else
				Rails.logger.info { 'Cron add tasks:'.fc_n_green }
				tasks.each(&:print)
				@tasks += tasks
			end
			Rails.logger.info { '' }
			tasks.each { |x| x.run if x.time == CronTime.now && @thread }
		end
		# @param [Symbol] tag
		# @param [CronTime] time
		# @param [Array] parameters
		# @param [Proc] block
		# @return [Meaningless]
		def add_delayed_task(tag, time, *parameters, &block)
			add_task(tag, time, false, *parameters, &block)
		end
		# @param [Symbol] tag
		# @param [CronTime] time
		# @param [Array] parameters
		# @param [Proc] block
		# @return [Meaningless]
		def add_repeated_task(tag, time, *parameters, &block)
			add_task(tag, time, true, *parameters, &block)
		end
		# @param [Hash] condition [Hash{tag: [NilClass, Symbol], time: [CronTime, NilClass], repeat: [FalseClass, NilClass, TrueClass]}]
		# @param [Proc] block
		# @return [Array<self>]
		def find(condition={}, &block)
			tasks = @tasks.clone
			ATTRIBUTE.each { |x1| tasks.keep_if { |x2| condition[x1].nil? || condition[x1] == x2.instance_variable_get(?@ + x1.to_s) } }
			tasks.keep_if(&block) if block
			tasks
		end
		# @param [Hash] condition [Hash{tag: [NilClass, Symbol], time: [CronTime, NilClass], repeat: [FalseClass, NilClass, TrueClass]}]
		# @param [Proc] block
		# @return [Meaningless]
		def delete(condition={}, &block)
			tasks = find(condition, &block)
			if tasks.empty?
				Rails.logger.info { 'Cron no task deleted : '.fc_n_green }
			else
				Rails.logger.info { 'Cron delete tasks:'.fc_n_green }
				tasks.each(&:print)
				@tasks -= tasks
			end
			show_tasks(true)
		end
		# @param [FalseClass, TrueClass] new_line
		# @return [Meaningless]
		def show_tasks(new_line)
			if @tasks.empty?
				Rails.logger.info { 'Cron no task'.fc_n_green }
			else
				Rails.logger.info { 'Cron tasks:'.fc_n_green }
				@tasks.each do |x1|
					x1.print
				end
			end
			Rails.logger.info { '' } if new_line
		end
		private
		# @param [Symbol] tag
		# @param [CronTime] time
		# @param [FalseClass, TrueClass] repeat
		# @param [Array] parameters
		# @param [Proc] block
		# @return [Meaningless]
		def add_task(tag, time, repeat, *parameters, &block)
			add_tasks(new(tag, time, repeat, *parameters, &block))
		end
		# @param [CronTime] time
		# @return [Meaningless]
		def do_task(time)
			Rails.logger.debug { "Cron do task at #{time.to_s}".fc_n_green }
			find(time: time).each(&:run)
		end
	end

end
