module AdminHelper
	def action_name_for_display
		action_name.titleize
	end
	def edit_account_script
		"workplaceList = #{ActiveSupport::JSON.encode({Car: Car.get_map, Shop: Shop.get_map, Store: Store.get_map})};
regionList = #{ActiveSupport::JSON.encode(Region.get_map)};
editAccountOnLoad(#{ActiveSupport::JSON.encode(@addresses)});".html_safe
	end
	def edit_inspect_task_plan_script
		"staffStoreList = #{ActiveSupport::JSON.encode(Staff.store_map)};".html_safe
	end
	def edit_transfer_task_plan_script
		"buildingList = #{ActiveSupport::JSON.encode({Shop: Shop.get_map, Store: Store.get_map})};".html_safe
	end
	def staff_accounts_table_contents
		Staff.all.collect { |x| "<tr>
  <td>#{x.id}</td>
  <td>#{x.username}</td>
  <td>#{x.name}</td>
  <td>#{x.email}</td>
  <td>#{x.phone}</td>
  <td>#{x.workplace_type}</td>
  <td>#{x.workplace_id}</td>
  <td>#{x.workplace.short_name}</td>
  <td>#{x.created_at.to_s}</td>
  <td>#{link_to('edit', action: :edit_account, account_id: x.id)}</td>
  <td>#{x.can_destroy ? link_to('delete', action: :delete_account, account_id: x.id) : link_to(x.enable ? 'disable' : 'enable', action: :enable_or_disable, object_type: RegisteredUser.to_s, object_id: x.id, redirect: :staff_accounts)}</td>
</tr>" }.join("\n").html_safe
	end
	def client_accounts_table_contents
		Client.all.collect { |x| "<tr>
  <td>#{x.id}</td>
  <td>#{x.username}</td>
  <td>#{x.name}</td>
  <td>#{x.email}</td>
  <td>#{x.phone}</td>
  <td>#{x.created_at}</td>
  <td>#{link_to('edit', action: :edit_account, account_id: x.id)}</td>
  <td>#{link_to(x.enable ? 'disable' : 'enable', action: :enable_or_disable, object_type: RegisteredUser.to_s, object_id: x.id, redirect: :client_accounts)}</td>
</tr>" }.join("\n").html_safe
	end
	def regions_table_contents
		Region.all.collect { |x| "<tr>
  <td>#{x.id}</td>
  <td>#{x.name}</td>
  <td>#{x.store_id}</td>
  <td>#{x.store.name}</td>
  <td>#{link_to('edit', action: :edit_region, region_id: x.id)}</td>
  <td>#{x.can_destroy ? link_to('delete', action: :delete_region, region_id: x.id) : link_to(x.enable ? 'disable' : 'enable', action: :enable_or_disable, object_type: Region.to_s, object_id: x.id, redirect: :regions)}</td>
</tr>" }.join("\n").html_safe
	end
	def shops_table_contents
		Shop.all.collect { |x1| "<tr>
  <td>#{x1.id}</td>
  <td>#{x1.address.gsub("\n", '<br />')}</td>
  <td>#{x1.region.name}</td>
  <td>#{x1.staffs.collect { |x2| x2.name }.join(',<br />')}</td>
  <td>#{link_to('edit', action: :edit_shop, shop_id: x1.id)}</td>
  <td>#{x1.can_destroy ? link_to('delete', action: :delete_shop, shop_id: x1.id) : link_to(x1.enable ? 'disable' : 'enable', action: :enable_or_disable, object_type: Shop.to_s, object_id: x1.id, redirect: :shops)}</td>
</tr>" }.join("\n").html_safe
	end
	def stores_table_contents
		Store.all.collect { |x1| "<tr>
  <td>#{x1.id}</td>
  <td>#{x1.address.gsub("\n", '<br />')}</td>
 <td>#{x1.size}</td>
  <td>#{x1.staffs.collect { |x2| x2.name }.join(',<br />')}</td>
  <td>#{link_to('edit', action: :edit_store, store_id: x1.id)}</td>
  <td>#{x1.can_destroy ? link_to('delete', action: :delete_store, store_id: x1.id) : link_to(x1.enable ? 'disable' : 'enable', action: :enable_or_disable, object_type: Store.to_s, object_id: x1.id, redirect: :stores)}</td>
</tr>" }.join("\n").html_safe
	end
	def cars_table_contents
		Car.all.collect { |x1| "<tr>
  <td>#{x1.id}</td>
  <td>#{x1.vehicle_registration_mark}</td>
  <td>#{x1.staffs.collect { |x2| x2.name }.join(',<br />')}</td>
  <td>#{link_to('edit', action: :edit_car, car_id: x1.id)}</td>
  <td>#{x1.can_destroy ? link_to('delete', action: :delete_car, car_id: x1.id) : link_to(x1.enable ? 'disable' : 'enable', action: :enable_or_disable, object_type: Car.to_s, object_id: x1.id, redirect: :cars)}</td>
</tr>" }.join("\n").html_safe
	end
	def conveyors_table_contents
		Conveyor.all.collect { |x| "<tr>
  <td>#{x.id}</td>
  <td>#{x.name}</td>
  <td>#{x.store_id}</td>
  <td>#{x.store.name}</td>
  <td>#{x.server_ip}</td>
  <td>#{x.server_port}</td>
  <td>#{x.passive ? '✓' : '✗'}</td>
  <td>#{link_to('edit', action: :edit_conveyor, conveyor_id: x.id)}</td>
  <td>#{link_to('delete', action: :delete_conveyor, conveyor_id: x.id)}</td>
</tr>" }.join("\n").html_safe
	end
	def inspect_task_plans_table_contents
		InspectTaskPlan.all.collect{ |x| "<tr>
  <td>#{x.id}</td>
  <td>#{day_display_html(x.day)}</td>
  <td>#{x.time.to_s(:time)}</td>
  <td>#{x.staff_id}</td>
  <td>#{x.staff.name}</td>
  <td>#{x.store_id}</td>
  <td>#{x.store.name}</td>
  <td>#{link_to('edit', action: :edit_inspect_task_plan, inspect_task_plan_id: x.id)}</td>
  <td>#{link_to('delete', action: :delete_inspect_task_plan, inspect_task_plan_id: x.id)}</td>
</tr>"}.join("\n").html_safe
	end
	def transfer_task_plans_table_contents
		TransferTaskPlan.all.collect{ |x| "<tr>
  <td>#{x.id}</td>
  <td>#{day_display_html(x.day)}</td>
  <td>#{x.time.to_s(:time)}</td>
  <td>#{x.car_id}</td>
  <td>#{x.car.short_name}</td>
  <td>#{x.from_type}</td>
  <td>#{x.from_id}</td>
  <td>#{x.from.name}</td>
  <td>#{x.to_type}</td>
  <td>#{x.to_id}</td>
  <td>#{x.to.name}</td>
  <td>#{x.number}</td>
  <td>#{link_to('edit', action: :edit_transfer_task_plan, transfer_task_plan_id: x.id)}</td>
  <td>#{link_to('delete', action: :delete_transfer_task_plan, transfer_task_plan_id: x.id)}</td>
</tr>"}.join("\n").html_safe
	end
	def visit_task_plans_table_contents
		VisitTaskPlan.all.collect{ |x| "<tr>
  <td>#{x.id}</td>
  <td>#{day_display_html(x.day)}</td>
  <td>#{x.time.to_s(:time)}</td>
  <td>#{x.car_id}</td>
  <td>#{x.car.name}</td>
  <td>#{x.store_id}</td>
  <td>#{x.store.name}</td>
  <td>#{x.send_receive_number}</td>
  <td>#{x.send_number}</td>
  <td>#{link_to('edit', action: :edit_visit_task_plan, visit_task_plan_id: x.id)}</td>
  <td>#{link_to('delete', action: :delete_visit_task_plan, visit_task_plan_id: x.id)}</td>
</tr>"}.join("\n").html_safe
	end
	def day_name(day)
		'SMTWTFS'[day]
	end
	def day_display_html(day)
		(0...7).collect { |t| "<span style=\"color: #{day[t] == 1 ? 'green' : 'lightgrey'};#{ ' font-weight: bold;' if day[t] == 1 }\">#{day_name(t)}</span>" }.join(' ').html_safe
	end
	def day_input(day=126)
		"<input id=\"input_day\" type=\"hidden\" name=\"day\" value=\"#{day}\" required />#{(0...7).collect { |t| "<a id=\"day#{t}\" style=\"color: #{day[t] == 1 ? 'green' : 'lightgrey'};#{ ' font-weight: bold;' if day[t] == 1 }\" onclick=\"dayChange(#{t});\">#{day_name(t)}</a>" }.join(' ')}".html_safe
	end
	def stores_select_options_for_default_staff_workplace(staff, store)
		if default_store = Staff.store_map[staff.to_s]
			"<option id=\"input_store_option_default\" value=\"#{default_store[:id]}\">#{default_store[:id]} - #{default_store[:name]} (workplace)</option>
#{stores_select_options(store == default_store[:id] ? nil : store)}".html_safe
		else
			"<option id=\"input_store_option_default\" value disabled>--</option>
#{stores_select_options(store)}".html_safe
		end
	end
	def cars_select_options(selected_id)
		Car.all.collect { |x| "<option value=\"#{x.id}\"#{' selected' if selected_id == x.id}>#{x.id} - #{x.short_name}</option>" }.join("\n").html_safe
	end
	def regions_select_options(selected_id)
		Region.all.collect { |x| "<option value=\"#{x.id}\"#{' selected' if selected_id == x.id}>#{x.id} - #{x.name}</option>" }.join("\n").html_safe
	end
	def staffs_select_options(selected_id)
		Staff.all.collect { |x| "<option value=\"#{x.id}\"#{' selected' if selected_id == x.id}>#{x.id} - #{x.name}</option>" }.join("\n").html_safe
	end
	def stores_select_options(selected_id)
		Store.all.collect { |x| "<option value=\"#{x.id}\"#{' selected' if selected_id == x.id}>#{x.id} - #{x.short_name}</option>" }.join("\n").html_safe
	end
	def error_message_div
		@error_message.collect { |x| "<div class=\"error_message\">
  #{x}
</div>" }.join("\n").html_safe if @error_message
	end
	def info_message_div
		@info_message.collect { |x| "<div class=\"info_message\">
  #{x}
</div>" }.join("\n").html_safe if @info_message
	end
	def warning_message_div
		@warning_message.collect { |x| "<div class=\"warning_message\">
  #{x}
</div>" }.join("\n").html_safe if @warning_message
	end
end
