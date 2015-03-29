class Cron
	ATTRIBUTE = [:tag, :time, :repeat]
	@tasks = []
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
	def run
		puts("run #{@tag} at #{@time.to_s}")
		begin
			@action.call(*@parameters, time)
		rescue
			puts('Corn error: ' + $!.message)
		end
		destroy unless @repeat
	end
	def destroy
		Cron.tasks.delete(self)
	end

	class << self
		attr_reader(:tasks)
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
		def add_delayed_task(tag, time, *parameters, &block)
			add_task(tag, time, false, *parameters, &block)
		end
		# @param [Symbol] tag
		# @param [CronTime] time
		# @param [Array] parameters
		# @param [Proc] block
		def add_repeated_task(tag, time, *parameters, &block)
			add_task(tag, time, true, *parameters, &block)
		end
		# @param [Hash] condition [Hash{tag: [NilClass, Symbol], time: [CronTime, NilClass], repeat: [FalseClass, NilClass, TrueClass]}]
		# @param [Proc] block
		# @param [Array<self>]
		def find(condition={}, &block)
			tasks = @tasks.clone
			ATTRIBUTE.each { |x1| tasks.keep_if { |x2| condition[x1].nil? || condition[x1] == x2.instance_variable_get(?@ + x1.to_s) } }
			tasks.keep_if(&block) if block
			tasks
		end
		# @param [Hash] condition [Hash{tag: [NilClass, Symbol], time: [CronTime, NilClass], repeat: [FalseClass, NilClass, TrueClass]}]
		# @param [Proc] block
		def delete(condition={}, &block)
			find(condition, &block).each(&:destroy)
		end
		private
		# @param [Symbol] tag
		# @param [CronTime] time
		# @param [FalseClass, TrueClass] repeat
		# @param [Array] parameters
		# @param [Proc] block
		def add_task(tag, time, repeat, *parameters, &block)
			@tasks << new(tag, time, repeat, *parameters, &block)
		end
		# @param [CronTime] time
		def do_task_at(time)
			puts("cron do task at #{time.to_s}")
			find(time: time).each(&:run)
		end
	end

end
