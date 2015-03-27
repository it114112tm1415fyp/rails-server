class Cron
	ATTRIBUTE = [:tag, :time, :repeat]
	@@tasks = []
	attr_accessor(*ATTRIBUTE)
	def initialize(tag, time, repeat, &block)
		@tag = tag
		@time = time
		@repeat = repeat
		@action = block
	end
	def run
		puts("run #{@tag} at ")
		begin
			@action.call(time)
		rescue
			puts('Corn error: ' + $!.message)
		end
		destroy unless @repeat
	end
	def destroy
		@@tasks.delete(self)
	end

	class << self
		def start
			@thread ||= Thread.new do
				loop do
					do_task_at(CronTime.now)
					now = Time.now
					sleep(now.at_end_of_minute - now)
					sleep(0.01)
				end
			end
		end
		def add_delayed_task(tag, time, *parameters, &block)
			add_task(tag, time, false, *parameters, &block)
		end
		def add_repeated_task(tag, time, *parameters, &block)
			add_task(tag, time, true, *parameters, &block)
		end
		def find(condition={}, &block)
			tasks = @@tasks
			ATTRIBUTE.each { |x1| tasks.keep_if { |x2| condition[x1].nil? || condition[x1] == x2.tag } }
			tasks.keep_if(&block) if block
			tasks
		end
		def delete(condition={}, &block)
			find(condition, &block).each(&:destroy)
		end
		private
		def add_task(tag, time, repeat, *parameters, &block)
			@@tasks << new(tag, time, repeat, *parameters, &block)
		end
		def do_task_at(time)
			find(time: time).each(&:run)
		end
	end

end
