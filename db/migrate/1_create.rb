class Create < ActiveRecord::Migration
	def up
		create_table(:cars) do |x|
			x.references(:driver)
			x.references(:partner)
			x.column(:vehicle_registration_mark, :string, limit: 8, null: false)
			x.index(:vehicle_registration_mark, unique: true)
		end
		create_table(:check_actions) do |x|
			x.column(:name, :string, null: false)
			x.index(:name, unique: true)
		end
		create_table(:check_logs, id: false) do |x|
			x.column(:time, :timestamp, null: false)
			x.references(:good, null: false)
			x.references(:location, polymorphic: true, null: false)
			x.references(:check_action, null: false)
			x.references(:staff, null: false)
		end
		create_table(:conveyors) do |x|
			x.column(:name, :string, limit: 40, null: false)
			x.references(:store_address, null: false)
			x.column(:server_ip, :string, null: false)
			x.column(:server_port, :integer, limit: 5, null: false)
			x.column(:passive, :boolean, null: false)
			x.index(:name, unique: true)
		end
		create_table(:conveyor_control_actions) do |x|
			x.column(:name, :string, null: false)
			x.index(:name, unique: true)
		end
		create_table(:conveyor_control_logs, id: false) do |x|
			x.column(:time, :timestamp, null: false)
			x.references(:conveyor, null: false)
			x.references(:conveyor_control_action, :string, null: false)
			x.references(:staff, null: false)
		end
		create_table(:goods) do |x|
			x.references(:order, null: false)
			x.references(:location, polymorphic: true, null: false)
			x.column(:rfid_tag, :string, limit: 40, null: false)
			x.column(:weight, :float, null: false)
			x.column(:fragile, :boolean, null: false)
			x.column(:flammable, :boolean, null: false)
			x.timestamps
		end
		create_table(:orders) do |x|
			x.references(:sender, null: false)
			x.references(:receiver, polymorphic: true, null: false)
			x.column(:receive_time, :timestamp)
			x.references(:staff, null: false)
			x.column(:pay_from_receiver, :boolean, null: false)
			x.column(:pay_time, :timestamp)
			x.timestamps
		end
		create_table(:permissions) do |x|
			x.column(:name, :string, limit: 40, null: false)
			x.index(:name, unique: true)
		end
		create_table(:permission_staff_ships, id: false) do |x|
			x.references(:permission, null: false)
			x.references(:staff, null: false)
		end
		create_table(:public_receivers) do |x|
			x.column(:name, :string, limit: 40)
			x.column(:email, :string)
			x.column(:phone, :string, limit: 17)
		end
		create_table(:shop_addresses) do |x|
			x.column(:address, :string, null: false)
			x.index(:address, unique: true)
		end
		create_table(:specify_addresses) do |x|
			x.column(:address, :string, null: false)
			x.index(:address, unique: true)
		end
		create_table(:specify_addresses_user_ships, id: false) do |x|
			x.references(:specify_address, null: false)
			x.references(:user, polymorphic: true, null: false)
		end
		create_table(:store_addresses) do |x|
			x.column(:address, :string, null: false)
			x.column(:size, :integer)
			x.index(:address, unique: true)
		end
		create_table(:registered_users) do |x|
			x.column(:username, :string, limit: 20)
			x.column(:password, :string, limit: 32)
			x.column(:is_freeze, :boolean)
			x.column(:name, :string, limit: 40, null: false)
			x.column(:email, :string, null: false)
			x.column(:phone, :string, limit: 17, null: false)
			x.column(:type, :string, limit: 40, null: false)
			x.timestamps
			x.index(:username, unique: true)
		end
		execute('ALTER TABLE `permission_staff_ships`       ADD PRIMARY KEY (`permission_id`,`staff_id`);')
		execute('ALTER TABLE `specify_addresses_user_ships` ADD PRIMARY KEY (`specify_address_id`,`user_id`);')
		execute('ALTER TABLE `cars`                         ADD FOREIGN KEY (`driver_id`)                  REFERENCES `registered_users`         (`id`);')
		execute('ALTER TABLE `cars`                         ADD FOREIGN KEY (`partner_id`)                 REFERENCES `registered_users`         (`id`);')
		execute('ALTER TABLE `check_logs`                   ADD FOREIGN KEY (`check_action_id`)            REFERENCES `check_actions`            (`id`);')
		execute('ALTER TABLE `check_logs`                   ADD FOREIGN KEY (`good_id`)                    REFERENCES `goods`                    (`id`);')
		execute('ALTER TABLE `check_logs`                   ADD FOREIGN KEY (`staff_id`)                   REFERENCES `registered_users`         (`id`);')
		execute('ALTER TABLE `conveyors`                    ADD FOREIGN KEY (`store_address_id`)           REFERENCES `store_addresses`          (`id`);')
		execute('ALTER TABLE `conveyor_control_logs`        ADD FOREIGN KEY (`conveyor_id`)                REFERENCES `conveyors`                (`id`);')
		execute('ALTER TABLE `conveyor_control_logs`        ADD FOREIGN KEY (`conveyor_control_action_id`) REFERENCES `conveyor_control_actions` (`id`);')
		execute('ALTER TABLE `conveyor_control_logs`        ADD FOREIGN KEY (`staff_id`)                   REFERENCES `registered_users`         (`id`);')
		execute('ALTER TABLE `goods`                        ADD FOREIGN KEY (`order_id`)                   REFERENCES `orders`                   (`id`);')
		execute('ALTER TABLE `orders`                       ADD FOREIGN KEY (`sender_id`)                  REFERENCES `registered_users`         (`id`);')
		execute('ALTER TABLE `orders`                       ADD FOREIGN KEY (`staff_id`)                   REFERENCES `registered_users`         (`id`);')
		execute('ALTER TABLE `permission_staff_ships`       ADD FOREIGN KEY (`permission_id`)              REFERENCES `permissions`              (`id`);')
		execute('ALTER TABLE `permission_staff_ships`       ADD FOREIGN KEY (`staff_id`)                   REFERENCES `registered_users`         (`id`);')
		execute('ALTER TABLE `specify_addresses_user_ships` ADD FOREIGN KEY (`specify_address_id`)         REFERENCES `specify_addresses`        (`id`);')
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
