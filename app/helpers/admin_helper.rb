module AdminHelper
	def action_name_for_display
		action_name.split(/_/).collect(&:capitalize).join(' ')
	end
	def edit_account_script_content
		"regionList = #{ActiveSupport::JSON.encode(Region.get_map)};
editAccountOnLoad(#{ActiveSupport::JSON.encode(@addresses)});".html_safe
	end
	def staff_accounts_table_contents
		Staff.where.not(type: 'Admin').all.collect { |x| "<tr>\n  <td>#{x.id}</td>\n  <td>#{x.username}</td>\n  <td>#{x.name}</td>\n  <td>#{x.email}</td>\n  <td>#{x.phone}</td>\n  <td>#{x.car.vehicle_registration_mark if x.car}</td>\n  <td>#{x.driver ? '✓' : '✗' if x.driver != nil}</td>\n  <td>#{x.partner.id if x.partner}</td>\n  <td>#{x.partner.name if x.partner}</td>\n  <td>#{x.created_at}</td>\n  <td>#{link_to(x.is_freeze ? 'unfreeze' : 'freeze', action: :freeze_account, account_id: x.id)}</td>\n  <td>#{link_to('edit', action: :edit_account, account_id: x.id)}</td>\n  <td>#{link_to_if(x.can_destroy, 'delete', action: :delete_account, account_id: x.id)}</td>\n</tr>" }.join("\n").html_safe
	end
	def client_accounts_table_contents
		Client.all.collect { |x| "<tr>\n  <td>#{x.id}</td>\n  <td>#{x.username}</td>\n  <td>#{x.name}</td>\n  <td>#{x.email}</td>\n  <td>#{x.phone}</td>\n  <td>#{x.created_at}</td>\n  <td>#{link_to(x.is_freeze ? 'unfreeze' : 'freeze', action: :freeze_account, account_id: x.id)}</td>\n  <td>#{link_to('edit', action: :edit_account, account_id: x.id)}</td>\n</tr>" }.join("\n").html_safe
	end
	def shops_table_contents
		Shop.all.collect { |x| "<tr>\n  <td>#{x.id}</td>\n  <td>#{x.address.gsub("\n", '<br />')}</td>\n  <td>#{x.region.name}</td>\n <td>#{link_to('edit', action: :edit_shop, shop_id: x.id)}</td>\n  <td>#{link_to_if(x.can_destroy, 'delete', action: :delete_shop, shop_id: x.id)}</td>\n</tr>" }.join("\n").html_safe
	end
	def stores_table_contents
		Store.all.collect { |x| "<tr>\n  <td>#{x.id}</td>\n  <td>#{x.address.gsub("\n", '<br />')}</td>\n <td>#{x.size}</td>\n <td>#{link_to('edit', action: :edit_store, store_id: x.id)}</td>\n  <td>#{link_to_if(x.can_destroy, 'delete', action: :delete_store, store_id: x.id)}</td>\n</tr>" }.join("\n").html_safe
	end
	def conveyors_table_contents
		Conveyor.all.collect { |x| "<tr>\n  <td>#{x.id}</td>\n  <td>#{x.name}</td>\n  <td>#{x.store.id}</td>\n  <td>#{x.store.address}</td>\n  <td>#{x.server_ip}</td>\n  <td>#{x.server_port}</td>\n  <td>#{x.passive ? '✓' : '✗'}</td>\n  <td>#{link_to('edit', action: :edit_conveyor, conveyor_id: x.id)}</td>\n  <td>#{link_to_if(x.can_destroy, 'delete', action: :delete_conveyor, conveyor_id: x.id)}</td>\n</tr>" }.join("\n").html_safe
	end
	def conveyors_select_options
		Store.all.collect { |x| "<option value=\"#{x.id}\">#{x.display_name}</option>" }.join("\n").gsub(/\r|\n/, ' ').html_safe
	end
	def cars_table_contents
		Car.all.collect { |x| "<tr>\n  <td>#{x.id}</td>\n  <td>#{x.vehicle_registration_mark}</td>\n  <td>#{x.driver.id if x.driver}</td>\n  <td>#{x.driver.name if x.driver}</td>\n  <td>#{x.helper.id if x.helper}</td>\n  <td>#{x.helper.name if x.helper}</td>\n  <td>#{link_to('edit', action: :edit_car, car_id: x.id)}</td>\n  <td>#{link_to('delete', action: :delete_car, car_id: x.id)}</td>\n</tr>" }.join("\n").html_safe
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
