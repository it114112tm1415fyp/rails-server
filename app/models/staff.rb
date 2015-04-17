class Staff < RegisteredUser
	belongs_to(:workplace, polymorphic: true)
	has_many(:task_workers)
	has_many(:goods, class_name: Goods)
	has_many(:orders)
	validates_presence_of(:workplace)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		super(Option.new(options, include: :workplace))
	end
	# @return [FalseClass, TrueClass]
	def can_destroy
		task_workers.size == 0
	end
	# @return [FalseClass, TrueClass]
	def edit_account(username, password, name, email, phone, workplace_type, workplace_id, addresses, enable)
		raise(ParameterError, 'workplace_type') unless [Car.name, Shop.name, Store.name].include?(workplace_type)
		transaction do
			error('username used') if self.username != username && RegisteredUser.find_by_username(username)
			self.username = username
			self.password = password
			self.name = name
			self.email = email
			self.phone = phone
			self.workplace = Object.const_get(workplace_type).find(workplace_id)
			self.enable = enable
			change_address(addresses)
		end
	end
	# TODO IMPROVE SQL QUERY
	# @return [ActiveRecord::Relation]
	def today_task_workers
		task_worker_table_name = TaskWorker.table_name
		select = "SELECT `#{task_worker_table_name}`.*"
		from = " FROM `#{task_worker_table_name}`"
		where = " WHERE `#{task_worker_table_name}`.`#{:staff_id}` = #{id} AND"
		join_array = []
		where_array = []
		beginning_of_day = Date.today.beginning_of_day.to_s(:db)
		end_of_day = Date.today.end_of_day.to_s(:db)
		TaskManager::TASK_CLASS.collect(&:base_class).uniq.each do |x|
			table_name = x.table_name
			join_array << " LEFT JOIN `#{table_name}` AS `#{table_name}` ON `#{table_name}`.`id` = `#{task_worker_table_name}`.`#{:task_id}` AND `#{task_worker_table_name}`.`#{:task_type}` = '#{x.name}'"
			where_array << " `#{table_name}`.`#{:datetime}` BETWEEN '#{beginning_of_day}' AND '#{end_of_day}'"
		end
		sql = select + from + join_array.join + where + ' (' + where_array.join(' OR') + ' )'
		TaskWorker.find_by_sql(sql)
	end

	class << self
		# @return [Hash]
		def store_map
			result = {}
			all.each { |x| result[x.id.to_s] = {id: x.workplace.id, name: x.workplace.short_name} if x.workplace.is_a?(Store) }
			result
		end
		# @param [String] username
		# @param [String] password
		# @return [Staff]
		def login(username, password)
			staff = find_by_username(username)
			error('Username not exist') unless staff
			transform = /\A~!@\$&\*\((.+?)\)\.md5\.md5\z/
			password = Digest::MD5.hexdigest(Digest::MD5.hexdigest($1)) if Rails.env.development? && transform.match(password)
			staff.check_password(password)
			error('Account frozen') unless staff.enable
			staff
		end
		# @param [String] username
		# @param [String] password
		# @param [String] name
		# @param [String] email
		# @param [String] phone
		# @param [String] workplace_type
		# @param [Integer] workplace_id
		# @param [String] addresses
		# @param [FalseClass, TrueClass] enable
		# @return [self]
		def register(username, password, name, email, phone, workplace_type, workplace_id, addresses, enable)
			raise(ParameterError, 'workplace_type') unless [Car.name, Shop.name, Store.name].include?(workplace_type)
			ActiveRecord::Base.transaction do
				error('username used') if RegisteredUser.find_by_username(username)
				staff = create!(username: username, password: password, name: name, email: email, phone: phone, workplace: Object.const_get(workplace_type).find(workplace_id), enable: enable)
				staff.change_address(addresses)
			end
		end
	end

end
