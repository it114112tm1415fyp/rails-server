module AdminHelper
	def action_name_for_display
		action_name.split(/_/).collect(&:capitalize).join(' ')
	end
	def edit_account_script_content
		"workplaceList = #{ActiveSupport::JSON.encode({Car: Car.get_map, Shop: Shop.get_map, Store: Store.get_map})};
regionList = #{ActiveSupport::JSON.encode(Region.get_map)};
editAccountOnLoad(#{ActiveSupport::JSON.encode(@addresses)});".html_safe
	end
	def staff_accounts_table_contents
		Staff.where.not(type: 'Admin').all.collect { |x| "<tr>\n  <td>#{x.id}</td>\n  <td>#{x.username}</td>\n  <td>#{x.name}</td>\n  <td>#{x.email}</td>\n  <td>#{x.phone}</td>\n  <td>#{x.workplace.class.to_s}</td>\n  <td>#{x.workplace.id}</td>\n  <td>#{x.workplace.name}</td>\n  <td>#{x.created_at}</td>\n  <td>#{link_to('edit', action: :edit_account, account_id: x.id)}</td>\n  <td>#{x.can_destroy ? link_to('delete', action: :delete_account, account_id: x.id) : link_to(x.enable ? 'disable' : 'enable', action: :enable_or_disable, object_type: RegisteredUser.to_s, object_id: x.id, redirect: :staff_accounts)}</td>\n</tr>" }.join("\n").html_safe
	end
	def client_accounts_table_contents
		Client.all.collect { |x| "<tr>\n  <td>#{x.id}</td>\n  <td>#{x.username}</td>\n  <td>#{x.name}</td>\n  <td>#{x.email}</td>\n  <td>#{x.phone}</td>\n  <td>#{x.created_at}</td>\n  <td>#{link_to('edit', action: :edit_account, account_id: x.id)}</td>\n  <td>#{link_to(x.enable ? 'disable' : 'enable', action: :enable_or_disable, object_type: RegisteredUser.to_s, object_id: x.id, redirect: :client_accounts)}</td>\n</tr>" }.join("\n").html_safe
	end
	def cars_table_contents
		Car.all.collect { |x1| "<tr>\n  <td>#{x1.id}</td>\n  <td>#{x1.vehicle_registration_mark}</td>\n  <td>#{x1.staffs.collect { |x2| x2.name }.join(',<br />')}</td>\n  <td>#{link_to('edit', action: :edit_car, car_id: x1.id)}</td>\n  <td>#{x1.can_destroy ? link_to('delete', action: :delete_car, car_id: x1.id) : link_to(x1.enable ? 'disable' : 'enable', action: :enable_or_disable, object_type: Car.to_s, object_id: x1.id, redirect: :cars)}</td>\n</tr>" }.join("\n").html_safe
	end
	def shops_table_contents
		Shop.all.collect { |x1| "<tr>\n  <td>#{x1.id}</td>\n  <td>#{x1.address.gsub("\n", '<br />')}</td>\n  <td>#{x1.region.name}</td>\n  <td>#{x1.staffs.collect { |x2| x2.name }.join(',<br />')}</td>\n  <td>#{link_to('edit', action: :edit_shop, shop_id: x1.id)}</td>\n  <td>#{x1.can_destroy ? link_to('delete', action: :delete_shop, shop_id: x1.id) : link_to(x1.enable ? 'disable' : 'enable', action: :enable_or_disable, object_type: Shop.to_s, object_id: x1.id, redirect: :shops)}</td>\n</tr>" }.join("\n").html_safe
	end
	def stores_table_contents
		Store.all.collect { |x1| "<tr>\n  <td>#{x1.id}</td>\n  <td>#{x1.address.gsub("\n", '<br />')}</td>\n <td>#{x1.size}</td>\n  <td>#{x1.staffs.collect { |x2| x2.name }.join(',<br />')}</td>\n  <td>#{link_to('edit', action: :edit_store, store_id: x1.id)}</td>\n  <td>#{x1.can_destroy ? link_to('delete', action: :delete_store, store_id: x1.id) : link_to(x1.enable ? 'disable' : 'enable', action: :enable_or_disable, object_type: Store.to_s, object_id: x1.id, redirect: :stores)}</td>\n</tr>" }.join("\n").html_safe
	end
	def conveyors_table_contents
		Conveyor.all.collect { |x| "<tr>\n  <td>#{x.id}</td>\n  <td>#{x.name}</td>\n  <td>#{x.store.id}</td>\n  <td>#{x.store.name}</td>\n  <td>#{x.server_ip}</td>\n  <td>#{x.server_port}</td>\n  <td>#{x.passive ? '✓' : '✗'}</td>\n  <td>#{link_to('edit', action: :edit_conveyor, conveyor_id: x.id)}</td>\n  <td>#{link_to('delete', action: :delete_conveyor, conveyor_id: x.id)}</td>\n</tr>" }.join("\n").html_safe
	end
	def conveyors_select_options
		Store.all.collect { |x| "<option value=\"#{x.id}\">#{x.name.gsub(/\r|\n/, ' ')}</option>" }.join("\n").html_safe
	end
	def error_message_div
		@error_message.collect { |x| "<div class=\"error_message\">\n  #{x}\n</div>" }.join("\n").html_safe if @error_message
	end
	def info_message_div
		@info_message.collect { |x| "<div class=\"info_message\">\n  #{x}\n</div>" }.join("\n").html_safe if @info_message
	end
	def warning_message_div
		@warning_message.collect { |x| "<div class=\"warning_message\">\n  #{x}\n</div>" }.join("\n").html_safe if @warning_message
	end
end
