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
		create_table(:check_logs, id: false, bulk: true) do |x|
			x.column(:time, :timestamp, null: false)
			x.references(:good, null: false)
			x.references(:location, polymorphic: true, null: false)
			x.references(:check_action, null: false)
			x.references(:staff, null: false)
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
			x.column(:date, :date, null: false)
			x.column(:free, :integer, null: false)
		end
		create_table(:goods, bulk: true) do |x|
			x.references(:order, null: false)
			x.references(:location, polymorphic: true, null: false)
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
		create_table(:metal_gateways, bulk: true) do |x|
			x.column(:name, :string, limit: 40, null: false)
			x.references(:store, null: false)
			x.column(:server_ip, :string, null: false)
			x.index(:name, unique: true)
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
			x.timestamps(null: false)
		end
		create_table(:order_status, bulk: true) do |x|
			x.column(:name, :string, limit: 40, null: false)
			x.index(:name, unique: true)
		end
		create_table(:public_receivers, bulk: true) do |x|
			x.column(:name, :string, limit: 40, null: false)
			x.column(:email, :string, null: false)
			x.column(:phone, :string, limit: 17, null: false)
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
		create_table(:specify_address_user_ships, id: false, bulk: true) do |x|
			x.references(:specify_address, null: false)
			x.references(:user, polymorphic: true, null: false)
		end
		create_table(:stores, bulk: true) do |x|
			x.column(:name, :string, limit: 40, null: false)
			x.column(:address, :string, null: false)
			x.column(:size, :integer, null: false)
			x.column(:enable, :boolean, null: false, default: true)
			x.index(:address, unique: true)
		end
		create_table(:inspect_task_plans, bulk: true) do |x|
			x.column(:day, :integer, null: false)
			x.column(:time, :time, null: false)
			x.references(:staff, null: false)
			x.references(:store, null: false)
		end
		create_table(:inspect_tasks, bulk: true) do |x|
			x.column(:datetime, :datetime, null: false)
			x.references(:staff, null: false)
			x.references(:store, null: false)
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
			x.references(:staff, null: false)
			x.references(:car, null: false)
			x.references(:from, polymorphic: true, null: false)
			x.references(:to, polymorphic: true, null: false)
			x.column(:number, :integer, null: false)
		end
		create_table(:visit_task_plans, bulk: true) do |x|
			x.column(:day, :integer, null: false)
			x.column(:time, :time, null: false)
			x.references(:car, null: false)
			x.references(:store, null: false)
			x.column(:send_receive_number, :integer, null: false)
			x.column(:send_number, :integer, null: false)
		end
		create_table(:visit_tasks, bulk: true) do |x|
			x.column(:datetime, :datetime, null: false)
			x.references(:staff, null: false)
			x.references(:car, null: false)
			x.references(:store, null: false)
			x.column(:send_receive_number, :integer, null: false)
			x.column(:send_number, :integer, null: false)
		end
		execute('ALTER TABLE `specify_address_user_ships` ADD PRIMARY KEY (`specify_address_id`,`user_id`);')
		execute('ALTER TABLE `check_logs`                 ADD FOREIGN KEY (`check_action_id`)    REFERENCES `check_actions`     (`id`);')
		execute('ALTER TABLE `check_logs`                 ADD FOREIGN KEY (`good_id`)            REFERENCES `goods`             (`id`) ON DELETE CASCADE;')
		execute('ALTER TABLE `check_logs`                 ADD FOREIGN KEY (`staff_id`)           REFERENCES `registered_users`  (`id`);')
		execute('ALTER TABLE `conveyors`                  ADD FOREIGN KEY (`store_id`)           REFERENCES `stores`            (`id`);')
		execute('ALTER TABLE `free_times`                 ADD FOREIGN KEY (`order_id`)           REFERENCES `orders`            (`id`);')
		execute('ALTER TABLE `goods`                      ADD FOREIGN KEY (`order_id`)           REFERENCES `orders`            (`id`);')
		execute('ALTER TABLE `orders`                     ADD FOREIGN KEY (`sender_id`)          REFERENCES `registered_users`  (`id`);')
		execute('ALTER TABLE `orders`                     ADD FOREIGN KEY (`staff_id`)           REFERENCES `registered_users`  (`id`);')
		execute('ALTER TABLE `specify_address_user_ships` ADD FOREIGN KEY (`specify_address_id`) REFERENCES `specify_addresses` (`id`);')
	end
	def down
		execute('SET FOREIGN_KEY_CHECKS = 0;')
		execute("SELECT GROUP_CONCAT(' `', `table_schema`, '`.`', `table_name`, '`') INTO @tables FROM `information_schema`.`tables` WHERE `table_schema` = '#{Rails.configuration.database_configuration[Rails.env]['database']}' && `table_name` <> 'schema_migrations';")
		execute("SET @tables = CONCAT('DROP TABLE IF EXISTS', @tables);")
		execute('PREPARE statement FROM @tables;')
		execute('EXECUTE statement;')
		execute('DEALLOCATE PREPARE statement;')
		execute('SET FOREIGN_KEY_CHECKS = 1;')
	end
end
