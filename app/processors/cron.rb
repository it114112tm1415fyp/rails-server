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
		@tag = tag
		@time = time
		@repeat = repeat
		@parameters = parameters
		@action = block
	end
	# @return [Meaningless]
	def run
		Rails.logger.debug { "Cron run #{@tag} at #{@time.to_s}".green.on_light_black }
		begin
			@action.call(*@parameters, time)
		rescue
			Rails.logger.error { "Cron error: #{$!.message}".light_red }
		end
		destroy unless @repeat
	end
	# @param [FalseClass, TrueClass] show_tasks
	# @return [Meaningless]
	def destroy(show_tasks=true)
		Cron.tasks.delete(self)
		Rails.logger.info { 'Cron delete task:'.green.on_light_black }
		print
		Cron.show_tasks if show_tasks
	end
	# @return [Meaningless]
	def print
		Rails.logger.info { "  #{ATTRIBUTE.collect { |x| "#{x.to_s} : ".green + ("%-#{PRINT_SIZE[x]}s" % "#{send(x)}").light_green }.join(' ')}".on_light_black }
	end

	class << self
		attr_reader(:tasks)
		# @return [Meaningless]
		def start
			@thread ||= Thread.new do
				loop do
					do_task_at(CronTime.now)
					now = Time.now
					sleep(now.at_end_of_minute - now + 0.000001)
				end
			end
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
			find(condition, &block).each { |x| x.destroy(false) }
			show_tasks
		end
		# @return [Meaningless]
		def show_tasks
			if @tasks.empty?
				Rails.logger.info { 'Cron no task'.green.on_light_black }
			else
				Rails.logger.info { 'Cron tasks:'.green.on_light_black }
				@tasks.each do |x1|
					x1.print
				end
			end
		end
		private
		# @param [Symbol] tag
		# @param [CronTime] time
		# @param [FalseClass, TrueClass] repeat
		# @param [Array] parameters
		# @param [Proc] block
		# @return [Meaningless]
		def add_task(tag, time, repeat, *parameters, &block)
			task = new(tag, time, repeat, *parameters, &block)
			@tasks << task
			Rails.logger.info { 'Cron add task:'.green.on_light_black }
			task.print
			show_tasks
		end
		# @param [CronTime] time
		# @return [Meaningless]
		def do_task_at(time)
			Rails.logger.debug { "Cron do task at #{time.to_s}".green.on_light_black }
			find(time: time).each(&:run)
		end
	end

end
