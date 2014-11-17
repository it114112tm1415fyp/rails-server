class Create < ActiveRecord::Migration
	def up
		create_table(:addresses) do |x|
			x.column(:address, :string, null: false)
			x.column(:size, :integer)
			x.references(:address_type, null: false)
			x.timestamps
			x.index(:address, unique: true)
		end
		create_table(:address_types) do |x|
			x.column(:name, :string, null: false)
			x.column(:has_size, :boolean, null: false)
			x.column(:is_unique, :boolean, null: false, default: false)
			x.index(:name, unique: true)
		end
		create_table(:address_user_ships, id: false) do |x|
			x.references(:address, null: false)
			x.references(:user, null: false)
		end
		create_table(:check_actions) do |x|
			x.column(:name, :string, null: false)
			x.index(:name, unique: true)
		end
		create_table(:check_logs, id: false) do |x|
			x.column(:time, :timestamp, null: false)
			x.references(:good, null: false)
			x.references(:location, null: false)
			x.references(:check_action, null: false)
			x.references(:staff, null: false)
		end
		create_table(:conveyors) do |x|
			x.column(:name, :string, limit: 40, null: false)
			x.references(:location, null: false)
			x.column(:server_ip, :string, null: false)
			x.column(:server_port, :integer, limit: 5, null: false)
			x.column(:passive, :boolean, null: false)
			x.index(:name, unique: true)
		end
		create_table(:goods) do |x|
			x.references(:order, null: false)
			x.references(:location, null: false)
			x.column(:rfid_tag, :string, limit: 40, null: false)
			x.column(:weight, :float, null: false)
			x.column(:fragile, :boolean, null: false)
			x.column(:flammable, :boolean, null: false)
			x.timestamps
		end
		create_table(:orders) do |x|
			x.references(:sender, null: false)
			x.references(:receiver, null: false)
			x.column(:receive_time, :timestamp)
			x.references(:staff, null: false)
			x.references(:payer, null: false)
			x.column(:pay_time, :timestamp)
			x.timestamps
		end
		create_table(:permissions) do |x|
			x.column(:name, :string, limit: 40, null: false)
			x.index(:name, unique: true)
		end
		create_table(:permission_user_ships, id: false) do |x|
			x.references(:permission, null: false)
			x.references(:user, null: false)
		end
		create_table(:users) do |x|
			x.column(:username, :string, limit: 20)
			x.column(:password, :string, limit: 32)
			x.column(:is_freeze, :boolean)
			x.column(:name, :string, limit: 40, null: false)
			x.column(:email, :string, null: false)
			x.column(:phone, :string, limit: 17, null: false)
			x.references(:user_type, null: false)
			x.timestamps
			x.index(:username, unique: true)
		end
		create_table(:user_types) do |x|
			x.column(:name, :string, null: false)
			x.column(:is_unique, :boolean, null: false, default: false)
			x.column(:can_login, :boolean, null: false, default: true)
			x.index(:name, unique: true)
		end
		execute('ALTER TABLE `address_user_ships`    ADD PRIMARY KEY (`address_id`,`user_id`);')
		execute('ALTER TABLE `permission_user_ships` ADD PRIMARY KEY (`permission_id`,`user_id`);')
		execute('ALTER TABLE `addresses`             ADD FOREIGN KEY (`address_type_id`) REFERENCES `address_types` (`id`);')
		execute('ALTER TABLE `address_user_ships`    ADD FOREIGN KEY (`address_id`)      REFERENCES `addresses`     (`id`);')
		execute('ALTER TABLE `address_user_ships`    ADD FOREIGN KEY (`user_id`)         REFERENCES `users`         (`id`);')
		execute('ALTER TABLE `check_logs`            ADD FOREIGN KEY (`check_action_id`) REFERENCES `check_actions` (`id`);')
		execute('ALTER TABLE `check_logs`            ADD FOREIGN KEY (`good_id`)         REFERENCES `goods`         (`id`);')
		execute('ALTER TABLE `check_logs`            ADD FOREIGN KEY (`staff_id`)        REFERENCES `users`         (`id`);')
		execute('ALTER TABLE `check_logs`            ADD FOREIGN KEY (`location_id`)     REFERENCES `addresses`     (`id`);')
		execute('ALTER TABLE `conveyors`             ADD FOREIGN KEY (`location_id`)     REFERENCES `addresses`     (`id`);')
		execute('ALTER TABLE `goods`                 ADD FOREIGN KEY (`order_id`)        REFERENCES `orders`        (`id`);')
		execute('ALTER TABLE `goods`                 ADD FOREIGN KEY (`location_id`)     REFERENCES `addresses`     (`id`);')
		execute('ALTER TABLE `orders`                ADD FOREIGN KEY (`payer_id`)        REFERENCES `users`         (`id`);')
		execute('ALTER TABLE `orders`                ADD FOREIGN KEY (`receiver_id`)     REFERENCES `users`         (`id`);')
		execute('ALTER TABLE `orders`                ADD FOREIGN KEY (`sender_id`)       REFERENCES `users`         (`id`);')
		execute('ALTER TABLE `orders`                ADD FOREIGN KEY (`staff_id`)        REFERENCES `users`         (`id`);')
		execute('ALTER TABLE `permission_user_ships` ADD FOREIGN KEY (`permission_id`)   REFERENCES `permissions`   (`id`);')
		execute('ALTER TABLE `permission_user_ships` ADD FOREIGN KEY (`user_id`)         REFERENCES `users`         (`id`);')
		execute('ALTER TABLE `users`                 ADD FOREIGN KEY (`user_type_id`)    REFERENCES `user_types`    (`id`);')
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
