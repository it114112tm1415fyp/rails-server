class ServeTask < ActiveRecord::Base
	TASK_OBJECT_CLASS = GoodsServeTaskShip
	belongs_to(:shop)
	has_many(:goods_serve_task_ships, dependent: :destroy)
	has_many(:goods, class_name: Goods, through: :goods_serve_task_ships)
	has_many(:staffs, through: :task_workers)
	has_many(:task_workers, as: :task, dependent: :destroy)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, except: :shop_id, include: [:staffs, :shop, {goods: {collect: :string_id}}], method: :type, rename: {goods: :scanned_goods}))
	end
	# @return [Integer]
	def task_code
		id
	end
	# @return [CheckAction] check_action
	# @return [TrueClass]
	def can_do(check_action)
		true
	end

	class << self
		# @return [ActiveRecord::Relation]
		def today
			where(datetime: Date.today.beginning_of_day..Date.today.end_of_day)
		end
		# @return [Meaningless]
		def prepare
			unless generate_today_task
				now = Time.now
				tasks = today.where(datetime: now..now.at_end_of_day)
				tasks.collect! { |x| Cron.new(self::CRON_TASK_TAG, x.datetime.to_ct, false, x, &self::CRON_TASK_CONTENT) }
				Cron.add_tasks(*tasks)
			end
		end
		# @param [FalseClass, TrueClass] force
		# @return [FalseClass, TrueClass]
		def generate_today_task(force=false)
			need_generate = need_generate_today_task
			if result = need_generate
				time = Date.today.at_beginning_of_day
				transaction do
					Shop.enabled.collect do |x1|
						task = create!(datetime: time, shop: x1)
						x1.staffs.each do |x2|
							TaskWorker.create!(task: task, staff: x2, check_action: CheckAction.receive)
							TaskWorker.create!(task: task, staff: x2, check_action: CheckAction.issue)
						end
					end
				end
			end
			result
		end
		# @return [FalseClass, TrueClass]
		def need_generate_today_task
			today.empty?
		end
	end

end
