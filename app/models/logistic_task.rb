class LogisticTask < ActiveRecord::Base
	IGNORE_ATTRIBUTES = [:id, :type, :day, :time]
	SUBCLASS = []
	TASK_PLAN_INCLUDES = nil
	LogisticTask.abstract_class = true
	has_many(:staffs, through: :task_workers)
	has_many(:task_workers, as: :task, dependent: :destroy)
	after_find(:generate)
	# @return [GoodsTaskShips]
	def task_objects
		send(self.class::TASK_OBJECT_TYPE.to_s + '_queue')
	end
	# @return [FalseClass, TrueClass]
	def generate(force=false)
		if datetime.past? && !generated || force
			if generated
				self.class::TASK_OBJECT_CLASS.destroy_all(self.class.name.underscore.to_sym => self)
			end
			transaction do
				Array(task_objects).each { |x| self.class::TASK_OBJECT_CLASS.create!(self.class.name.underscore.to_sym => self, self.class::TASK_OBJECT_TYPE => x) }
				self.generated = true
				save!
			end
		end
	end
	# @return [Integer]
	def task_code
		id
	end
	# @return [FalseClass, TrueClass]
	def check_completed
		return true if completed
		if self.class::CHECK_ACTION.all? { |x| partly_completed(x) }
			self.completed = true
			save!
		end
	end
	# @return [FalseClass, TrueClass]
	def partly_completed(check_action)
		return false unless ready(check_action)
		goods_task_ships.all? { |x| x.has_check_log(check_action) }
	end
	# @param [Goods] goods
	# @param [TaskWorker] task_worker
	# @param [Hash] addition
	def edit_goods(goods, task_worker, addition)
		not_implemented
	end
	# @return [CheckAction] check_action
	# @return [FalseClass, TrueClass]
	def ready(check_action)
		generated
	end
	# @return [CheckAction] check_action
	# @return [TrueClass]
	def can_do(check_action)
		generated && !completed
	end
	class << self
		# @param [Array] args
		# @return [self]
		def add_debug_task_and_worker(*args)
			transaction do
				task = add_debug_task(*args)
				attributes = {}
				generate_task_add_attributes(task, attributes)
				task.task_workers = attributes[:task_workers]
				task.save!
				task
			end
		end
		# @return [ActiveRecord::Relation]
		def today
			where(datetime: Date.today.beginning_of_day..Date.today.end_of_day)
		end
		# @return [Meaningless]
		def prepare
			unless generate_today_task
				now = Time.now
				tasks = today.where(datetime: now..now.at_end_of_day)
				tasks.collect! { |x| Cron.new(self::CRON_TASK_TAG, x.datetime.to_ct, false, x, &:generate) }
				Cron.add_tasks(*tasks)
			end
		end
		# @param [FalseClass, TrueClass] force
		# @return [FalseClass, TrueClass]
		def generate_today_task(force=false)
			now = Time.now
			need_generate = need_generate_today_task
			if result = need_generate || force
				clear_today_task unless need_generate
				today = Date.today
				day = today.cwday % 7
				today = { year: today.year, month: today.month, day: today.day }
				tasks = []
				cron_tasks = []
				attributes = self::TASK_PLAN_CLASS.attribute_names.collect(&:to_sym) - self::IGNORE_ATTRIBUTES
				transaction do
					self::TASK_PLAN_CLASS.joins(self::TASK_PLAN_INCLUDES).includes(self::TASK_PLAN_INCLUDES).day(day).each do |x1|
						task = { datetime: x1.time.change(today) }
						attributes.each { |x2| task[x2] = x1.send(x2) }
						generate_task_add_attributes(x1, task)
						tasks << create!(task)
					end
				end
				tasks.each do |x|
					cron_tasks << Cron.new(self::CRON_TASK_TAG, x.datetime.to_ct, false, x, &:generate) if x.datetime >= now.at_beginning_of_minute
				end
				Cron.add_tasks(*cron_tasks)
			end
			result
		end
		# @param [Plan] plan
		# @param [Hash] task_attributes
		def generate_task_add_attributes(plan, task_attributes)
		end
		# @return [Meaningless]
		def clear_today_task
			today.destroy_all
			Cron.delete(tag: self::CRON_TASK_TAG)
		end
		# @return [FalseClass, TrueClass]
		def need_generate_today_task
			today.empty?
		end
	end

end
