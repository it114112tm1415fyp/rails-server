class Create < ActiveRecord::Migration
	def up
		create_table(:cars, bulk: true) do |x|
			x.column(:vehicle_registration_mark, :string, limit: 8, null: false)
			x.column(:enable, :boolean, null: false, default: true)
			x.index(:vehicle_registration_mark, unique: true)
		end
		create_table(:check_actions, bulk: true) do |x|
			x.column(:name, :string, limit: 40, null: false)
			x.index(:name, unique: true)
		end
		create_table(:check_logs, bulk: true) do |x|
			x.column(:time, :datetime, null: false)
			x.references(:task_worker, null: false)
			x.references(:task_goods, polymorphic: true, null: false)
		end
		create_table(:conveyors, bulk: true) do |x|
			x.column(:name, :string, limit: 40, null: false)
			x.references(:store, null: false)
			x.column(:server_ip, :string, null: false)
			x.column(:server_port, :integer, limit: 5, null: false)
			x.column(:passive, :boolean, null: false)
			x.index(:name, unique: true)
		end
		create_table(:free_times, bulk: true) do |x|
			x.references(:order, null: false)
			x.references(:receive_time_segment, null: false)
			x.column(:date, :date, null: false)
			x.column(:free, :boolean, null: false)
		end
		create_table(:goods, bulk: true) do |x|
			x.references(:order, null: false)
			x.references(:location, polymorphic: true, null: false)
			x.references(:next_stop, polymorphic: true, null: false)
			x.column(:shelf_id, :integer)
			x.references(:staff, null: false)
			x.references(:last_action, null: false)
			x.column(:string_id, :string, limit: 6, null: false)
			x.column(:rfid_tag, :string, limit: 29)
			x.column(:weight, :float, null: false)
			x.column(:fragile, :boolean, null: false)
			x.column(:flammable, :boolean, null: false)
			x.column(:goods_photo, :binary, null: false)
			x.timestamps(null: false)
			x.index(:string_id, unique: true)
			x.index(:rfid_tag, unique: true)
		end
		create_table(:goods_inspect_task_ships, bulk: true) do |x|
			x.references(:goods, null: false)
			x.references(:inspect_task, null: false)
			x.index([:goods_id, :inspect_task_id], unique: true, name: :goods_inspect_task_ships_unique)
		end
		create_table(:goods_visit_task_order_ships, bulk: true) do |x|
			x.references(:goods, null: false)
			x.references(:visit_task_order, null: false)
			x.index([:goods_id, :visit_task_order_id], unique: true, name: :goods_visit_task_order_ships_unique)
		end
		create_table(:goods_transfer_task_ships, bulk: true) do |x|
			x.references(:goods, null: false)
			x.references(:transfer_task, null: false)
			x.index([:goods_id, :transfer_task_id], unique: true, name: :goods_transfer_task_ships_unique)
		end
		create_table(:inspect_task_plans, bulk: true) do |x|
			x.column(:day, :integer, null: false)
			x.column(:time, :time, null: false)
			x.references(:store, null: false)
		end
		create_table(:inspect_tasks, bulk: true) do |x|
			x.column(:datetime, :datetime, null: false)
			x.references(:store, null: false)
			x.column(:generated, :boolean, null: false, default: false)
			x.column(:completed, :boolean, null: false, default: false)
		end
		create_table(:metal_gateways, bulk: true) do |x|
			x.column(:name, :string, limit: 40, null: false)
			x.references(:store, null: false)
			x.column(:server_ip, :string, null: false)
			x.index(:name, unique: true)
		end
		create_table(:order_status, bulk: true) do |x|
			x.column(:name, :string, limit: 40, null: false)
			x.index(:name, unique: true)
		end
		create_table(:order_queues, bulk: true) do |x|
			x.references(:order, null: false)
			x.column(:queue_times, :integer, null: false)
			x.column(:receive, :boolean, null: false)
			x.references(:visit_task)
			x.index(:order_id, unique: true)
		end
		create_table(:orders, bulk: true) do |x|
			x.references(:sender, null: false)
			x.column(:sender_sign, :binary)
			x.references(:receiver, polymorphic: true, null: false)
			x.column(:receiver_sign, :binary)
			x.references(:departure, polymorphic: true, null: false)
			x.references(:destination, polymorphic: true, null: false)
			x.column(:goods_number, :integer, null: false)
			x.references(:staff)
			x.references(:order_state, null: false)
			x.column(:receive_time_version, :datetime, null: false)
			x.timestamps(null: false)
		end
		create_table(:public_receivers, bulk: true) do |x|
			x.column(:name, :string, limit: 40, null: false)
			x.column(:email, :string, null: false)
			x.column(:phone, :string, limit: 17, null: false)
		end
		create_table(:receive_time_segments, bulk: true) do |x|
			x.column(:start_time, :time, null: false)
			x.column(:end_time, :time, null: false)
			x.column(:enable, :boolean, null: false, default: true)
			x.index([:start_time, :end_time], unique: true)
		end
		create_table(:registered_users, bulk: true) do |x|
			x.column(:username, :string, limit: 20, null: false)
			x.column(:password, :string, limit: 32, null: false)
			x.column(:name, :string, limit: 40, null: false)
			x.column(:email, :string, null: false)
			x.column(:phone, :string, limit: 17, null: false)
			x.column(:type, :string, limit: 40, null: false)
			x.references(:workplace, polymorphic: true)
			x.column(:enable, :boolean, null: false, default: true)
			x.timestamps(null: false)
			x.index(:username, unique: true)
		end
		create_table(:regions, bulk: true) do |x|
			x.column(:name, :string, limit: 40, null: false)
			x.references(:store, null: false)
			x.column(:enable, :boolean, null: false, default: true)
			x.index(:name, unique: true)
		end
		create_table(:shops, bulk: true) do |x|
			x.column(:name, :string, limit: 40, null: false)
			x.column(:address, :string, null: false)
			x.references(:region, null: false)
			x.column(:enable, :boolean, null: false, default: true)
			x.index(:address, unique: true)
		end
		create_table(:specify_addresses, bulk: true) do |x|
			x.column(:address, :string, null: false)
			x.references(:region, null: false)
			x.index([:address, :region_id], unique: true)
		end
		create_table(:specify_address_user_ships, bulk: true) do |x|
			x.references(:specify_address, null: false)
			x.references(:user, polymorphic: true, null: false)
			x.index([:specify_address_id, :user_id, :user_type], unique: true, name: :specify_address_user_ships_unique)
		end
		create_table(:stores, bulk: true) do |x|
			x.column(:name, :string, limit: 40, null: false)
			x.column(:address, :string, null: false)
			x.column(:shelf_number, :integer, null: false)
			x.column(:enable, :boolean, null: false, default: true)
			x.index(:address, unique: true)
		end
		create_table(:task_workers, bulk: true) do |x|
			x.references(:staff, null: false)
			x.references(:task, polymorphic: true, null: false)
			x.references(:check_action, null: false)
		end
		create_table(:transfer_task_plans, bulk: true) do |x|
			x.column(:day, :integer, null: false)
			x.column(:time, :time, null: false)
			x.references(:car, null: false)
			x.references(:from, polymorphic: true, null: false)
			x.references(:to, polymorphic: true, null: false)
			x.column(:number, :integer, null: false)
		end
		create_table(:transfer_tasks, bulk: true) do |x|
			x.column(:datetime, :datetime, null: false)
			x.references(:car, null: false)
			x.references(:from, polymorphic: true, null: false)
			x.references(:to, polymorphic: true, null: false)
			x.column(:number, :integer, null: false)
			x.column(:generated, :boolean, null: false, default: false)
			x.column(:completed, :boolean, null: false, default: false)
		end
		create_table(:scheme_versions) do |x|
			x.column(:scheme_name, :string, null: false)
			x.column(:scheme_update_time, :datetime, null: false)
		end
		create_table(:visit_task_orders, bulk: true) do |x|
			x.references(:order, null: false)
			x.references(:visit_task, null: false)
			x.column(:completed, :boolean, null: false, default: false)
			x.index([:order_id, :visit_task_id], unique: true, name: :order_visit_task_ships_unique)
		end
		create_table(:visit_task_plans, bulk: true) do |x|
			x.column(:day, :integer, null: false)
			x.column(:time, :time, null: false)
			x.references(:car, null: false)
			x.references(:region, null: false)
			x.column(:receive, :boolean, null: false)
			x.column(:number, :integer, null: false)
		end
		create_table(:visit_tasks, bulk: true) do |x|
			x.column(:datetime, :datetime, null: false)
			x.references(:car, null: false)
			x.references(:region, null: false)
			x.column(:receive, :boolean, null: false)
			x.column(:number, :integer, null: false)
			x.column(:generated, :boolean, null: false, default: false)
			x.column(:confirmed, :boolean, null: false, default: false)
			x.column(:completed, :boolean, null: false, default: false)
		end
		# execute('ALTER TABLE `specify_address_user_ships` ADD PRIMARY KEY (`specify_address_id`, `user_id`, `user_type`);')
		# execute('ALTER TABLE `inspect_task_goods_ship`    ADD PRIMARY KEY (`inspect_task_id`, `goods_id`);')
		# execute('ALTER TABLE `transfer_task_goods_ship`   ADD PRIMARY KEY (`transfer_task_id`, `goods_id`);')
		# execute('ALTER TABLE `visit_task_order_ship`      ADD PRIMARY KEY (`visit_task_id`, `goods_id`);')
		# execute('ALTER TABLE `check_logs`                 ADD FOREIGN KEY (`check_action_id`)         REFERENCES `check_actions`         (`id`)                  ;')
		# execute('ALTER TABLE `check_logs`                 ADD FOREIGN KEY (`goods_id`)                REFERENCES `goods`                 (`id`) ON DELETE CASCADE;')
		# execute('ALTER TABLE `check_logs`                 ADD FOREIGN KEY (`staff_id`)                REFERENCES `registered_users`      (`id`)                  ;')
		# execute('ALTER TABLE `conveyors`                  ADD FOREIGN KEY (`store_id`)                REFERENCES `stores`                (`id`)                  ;')
		# execute('ALTER TABLE `free_times`                 ADD FOREIGN KEY (`order_id`)                REFERENCES `orders`                (`id`)                  ;')
		# execute('ALTER TABLE `free_times`                 ADD FOREIGN KEY (`receive_time_segment_id`) REFERENCES `receive_time_segments` (`id`)                  ;')
		# execute('ALTER TABLE `goods`                      ADD FOREIGN KEY (`last_action_id`)          REFERENCES `check_actions`         (`id`)                  ;')
		# execute('ALTER TABLE `goods`                      ADD FOREIGN KEY (`order_id`)                REFERENCES `orders`                (`id`)                  ;')
		# execute('ALTER TABLE `goods`                      ADD FOREIGN KEY (`staff_id`)                REFERENCES `registered_users`      (`id`)                  ;')
		# execute('ALTER TABLE `inspect_task_goods`         ADD FOREIGN KEY (`goods_id`)                REFERENCES `goods`                 (`id`) ON DELETE CASCADE;')
		# execute('ALTER TABLE `inspect_task_goods`         ADD FOREIGN KEY (`inspect_task_id`)         REFERENCES `inspect_tasks`         (`id`) ON DELETE CASCADE;')
		# execute('ALTER TABLE `inspect_task_plans`         ADD FOREIGN KEY (`store_id`)                REFERENCES `stores`                (`id`)                  ;')
		# execute('ALTER TABLE `inspect_tasks`              ADD FOREIGN KEY (`store_id`)                REFERENCES `stores`                (`id`)                  ;')
		# execute('ALTER TABLE `metal_gateways`             ADD FOREIGN KEY (`store_id`)                REFERENCES `stores`                (`id`)                  ;')
		# execute('ALTER TABLE `orders`                     ADD FOREIGN KEY (`order_state_id`)          REFERENCES `order_status`          (`id`)                  ;')
		# execute('ALTER TABLE `orders`                     ADD FOREIGN KEY (`sender_id`)               REFERENCES `registered_users`      (`id`)                  ;')
		# execute('ALTER TABLE `orders`                     ADD FOREIGN KEY (`staff_id`)                REFERENCES `registered_users`      (`id`)                  ;')
		# execute('ALTER TABLE `regions`                    ADD FOREIGN KEY (`store_id`)                REFERENCES `stores`                (`id`)                  ;')
		# execute('ALTER TABLE `shops`                      ADD FOREIGN KEY (`region_id`)               REFERENCES `regions`               (`id`)                  ;')
		# execute('ALTER TABLE `specify_addresses`          ADD FOREIGN KEY (`region_id`)               REFERENCES `regions`               (`id`)                  ;')
		# execute('ALTER TABLE `specify_address_user_ships` ADD FOREIGN KEY (`specify_address_id`)      REFERENCES `specify_addresses`     (`id`)                  ;')
		# execute('ALTER TABLE `task_workers`               ADD FOREIGN KEY (`staff_id`)                REFERENCES `registered_users`      (`id`)                  ;')
		# execute('ALTER TABLE `task_workers`               ADD FOREIGN KEY (`task_worker_role_id`)     REFERENCES `task_worker_roles`     (`id`)                  ;')
		# execute('ALTER TABLE `transfer_task_goods`        ADD FOREIGN KEY (`goods_id`)                REFERENCES `goods`                 (`id`) ON DELETE CASCADE;')
		# execute('ALTER TABLE `transfer_task_goods`        ADD FOREIGN KEY (`transfer_task_id`)        REFERENCES `transfer_tasks`        (`id`) ON DELETE CASCADE;')
		# execute('ALTER TABLE `transfer_task_plans`        ADD FOREIGN KEY (`car_id`)                  REFERENCES `cars`                  (`id`)                  ;')
		# execute('ALTER TABLE `transfer_tasks`             ADD FOREIGN KEY (`car_id`)                  REFERENCES `cars`                  (`id`)                  ;')
		# execute('ALTER TABLE `visit_task_orders`          ADD FOREIGN KEY (`order_id`)                REFERENCES `orders`                (`id`)                  ;')
		# execute('ALTER TABLE `visit_task_orders`          ADD FOREIGN KEY (`visit_task_id`)           REFERENCES `visit_tasks`           (`id`) ON DELETE CASCADE;')
		# execute('ALTER TABLE `visit_task_plans`           ADD FOREIGN KEY (`car_id`)                  REFERENCES `cars`                  (`id`)                  ;')
		# execute('ALTER TABLE `visit_task_plans`           ADD FOREIGN KEY (`store_id`)                REFERENCES `stores`                (`id`)                  ;')
		# execute('ALTER TABLE `visit_tasks`                ADD FOREIGN KEY (`car_id`)                  REFERENCES `cars`                  (`id`)                  ;')
		# execute('ALTER TABLE `visit_tasks`                ADD FOREIGN KEY (`store_id`)                REFERENCES `stores`                (`id`)                  ;')
	end
	# def down
	# 	execute('SET FOREIGN_KEY_CHECKS = 0;')
	# 	execute("SELECT GROUP_CONCAT(' `', `table_schema`, '`.`', `table_name`, '`') INTO @tables FROM `information_schema`.`tables` WHERE `table_schema` = '#{Rails.configuration.database_configuration[Rails.env]['database']}' && `table_name` <> 'schema_migrations';")
	# 	execute("SET @tables = CONCAT('DROP TABLE IF EXISTS', @tables);")
	# 	execute('PREPARE statement FROM @tables;')
	# 	execute('EXECUTE statement;')
	# 	execute('DEALLOCATE PREPARE statement;')
	# 	execute('SET FOREIGN_KEY_CHECKS = 1;')
	# end
end
