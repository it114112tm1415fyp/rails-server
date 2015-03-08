class AdminController < WebApplicationController
	before_action(:check_login, except: [:test2, :login, :logout])
	def login
		@error_message = params[:error_message]
		@warning_message = params[:warning_message]
		@info_message = params[:info_message]
		if params_exist(:username, :password)
			session[:admin] = Admin.login(params[:username], params[:password]).id
		end
		if session[:admin]
			if params[:page]
				redirect_to(params[:page].to_hash)
			else
				redirect_to(action: :server_status)
			end
		end
	rescue Error
		redirect_to(action: :login, error_message: [$!.message])
	end
	def logout
		session.destroy
		redirect_to(action: :login)
	end
	def server_status
	end
	def staff_accounts
	end
	def client_accounts
	end
	def edit_profile
		@admin = Admin.find(session[:admin])
		if params_exist(:password, :new_password, :name, :email, :phone)
			@admin.edit_profile(params[:password], params[:new_password], params[:name], params[:email], params[:phone], nil)
		end
	rescue Error
		@error_message = [$!.message]
	ensure
		@name = params[:name] || @admin.name
		@email = params[:email] || @admin.email
		@phone = params[:phone] || @admin.phone
	end
	def enable_or_disable
		params_require(:object_type, :object_id, :redirect)
		raise(ParameterError, 'object_type') unless [Car.to_s, Region.to_s, RegisteredUser.to_s, Shop.to_s, Store.to_s].include?(params[:object_type])
		object = Object.const_get(params[:object_type]).find(params[:object_id])
		object.enable = !object.enable
		object.save!
		redirect_to(action: params[:redirect])
	end
	def new_staff_account
		if params_exist(:username, :password, :name, :email, :phone, :workplace_type, :workplace_id, :addresses)
			Staff.register(params[:username], params[:password], params[:name], params[:email], params[:phone], params[:workplace_type], params[:workplace_id], params[:addresses], params_exist(:enable))
			redirect_to(action: :staff_accounts)
		end
		@phone = '+852-'
		@addresses = []
	rescue Error
		@error_message = [$!.message]
		@username = params[:username]
		@name = params[:name]
		@email = params[:email]
		@phone = params[:phone]
		@workplace_type = params[:workplace_type]
		@workplace_id = params[:workplace_id]
		@addresses = params[:addresses]
		@enable = params_exist(:enable)
	ensure
		render(template: 'admin/edit_account') unless performed?
	end
	def edit_account
		params_require(:account_id)
		# @account = RegisteredUser.find(params[:account_id])
		# use ' || Staff.new' to trick the inferred type of @account in RubyMine
		@account = RegisteredUser.find(params[:account_id]) || Staff.new
		if params_exist(:username, :password, :name, :email, :phone, :addresses)
			@enable = params_exist(:enable)
			params[:password] = @account.password if params[:password].empty?
			if @account.is_a?(Staff) && params_exist(:workplace_type, :workplace_id)
				@account.edit_account(params[:username], params[:password], params[:name], params[:email], params[:phone], params[:workplace_type], params[:workplace_id], params[:addresses], @enable)
			else
				@account.edit_account(params[:username], params[:password], params[:name], params[:email], params[:phone], params[:addresses], @enable)
			end
			redirect_to(action: @account.type.downcase + '_accounts')
		end
	rescue Error
		@error_message = [$!.message]
	ensure
		@username = params[:username] || @account.username
		@name = params[:name] || @account.name
		@email = params[:email] || @account.email
		@phone = params[:phone] || @account.phone
		@workplace_type = params[:workplace_type] || @account.workplace_type
		@workplace_id = params[:workplace_id] || @account.workplace_id
		@enable ||= @account.enable
		@addresses = params[:addresses] || @account.specify_addresses.collect { |x| { address: x.address, region: x.region.id.to_s } }
	end
	def delete_account
		params_require(:account_id)
		account = RegisteredUser.find(params[:account_id])
		account.destroy if account.can_destroy
		redirect_to(action: account.type.downcase + '_accounts')
	end
	def regions
	end
	def new_region
		if params_exist(:name, :store)
			error('This region already exist') if Region.find_by_name(params[:name])
			Region.create!(name: params[:name], store_id: params[:store])
			redirect_to(action: :regions)
		end
	rescue Error
		@error_message = [$!.message]
		@name = params[:name]
		@store = params[:store]
	ensure
		render(template: 'admin/edit_region') unless performed?
	end
	def edit_region
		params_require(:region_id)
		@region = Region.find(params[:region_id])
		if params_exist(:name, :store)
			error('This region already exist') if @region.name != params[:name] && Region.find_by_name(params[:name])
			@region.name = params[:name]
			@region.store_id = params[:store]
			@region.save!
			redirect_to(action: :regions)
		end
	rescue Error
		@error_message = [$!.message]
	ensure
		@name = params[:name] || @region.name
		@store = params[:store] || @region.store_id
	end
	def delete_region
		params_require(:region_id)
		region = Region.find(params[:region_id])
		region.destroy if region.can_destroy
		redirect_to(action: :regions)
	end
	def shops
	end
	def new_shop
		if params_exist(:address, :region)
			error('This shop already exist') if Shop.find_by_address(params[:address])
			Shop.create!(address: params[:address], region_id: params[:region])
			redirect_to(action: :shops)
		end
	rescue Error
		@error_message = [$!.message]
		@address = params[:address]
		@region = params[:region]
	ensure
		render(template: 'admin/edit_shop') unless performed?
	end
	def edit_shop
		params_require(:shop_id)
		@shop = Shop.find(params[:shop_id])
		if params_exist(:address)
			error('This shop already exist') if @shop.address != params[:address] && Shop.find_by_address(params[:address])
			@shop.address = params[:address]
			@shop.region_id = params[:region]
			@shop.save!
			redirect_to(action: :shops)
		end
	rescue Error
		@error_message = [$!.message]
	ensure
		@address = params[:address] || @shop.long_name
		@region = params[:region] || @shop.region_id
	end
	def delete_shop
		params_require(:shop_id)
		shop = Shop.find(params[:shop_id])
		shop.destroy if shop.can_destroy
		redirect_to(action: :shops)
	end
	def stores
	end
	def new_store
		if params_exist(:address, :size)
			error('This store already exist') if Store.find_by_address(params[:address])
			Store.create!(address: params[:address], size: params[:size])
			redirect_to(action: :stores)
		end
	rescue Error
		@error_message = [$!.message]
		@address = params[:address]
		@size = params[:size]
	ensure
		render(template: 'admin/edit_store') unless performed?
	end
	def edit_store
		params_require(:store_id)
		@store = Store.find(params[:store_id])
		if params_exist(:address, :size)
			error('This store already exist') if @store.address != params[:address] && Store.find_by_address(params[:address])
			@store.address = params[:address]
			@store.size = params[:size]
			@store.save!
			redirect_to(action: :stores)
		end
	rescue Error
		@error_message = [$!.message]
	ensure
		@address = params[:address] || @store.long_name
		@size = params[:size] || @store.size
	end
	def delete_store
		params_require(:store_id)
		store = Store.find(params[:store_id])
		store.destroy if store.can_destroy
		redirect_to(action: :stores)
	end
	def cars
	end
	def new_car
		if params_exist(:vehicle_registration_mark)
			error('This car already exist') if Car.find_by_vehicle_registration_mark(params[:vehicle_registration_mark])
			Car.create!(vehicle_registration_mark: params[:vehicle_registration_mark])
			redirect_to(action: :cars)
		end
	rescue Error
		@error_message = [$!.message]
		@vehicle_registration_mark = params[:vehicle_registration_mark]
	ensure
		render(template: 'admin/edit_car') unless performed?
	end
	def edit_car
		params_require(:car_id)
		@car = Car.find(params[:car_id])
		if params_exist(:vehicle_registration_mark)
			error('This car already exist') if @car.vehicle_registration_mark != params[:vehicle_registration_mark] && Car.find_by_vehicle_registration_mark(params[:vehicle_registration_mark])
			@car.vehicle_registration_mark = params[:vehicle_registration_mark]
			@car.save!
			redirect_to(action: :cars)
		end
	rescue Error
		@error_message = [$!.message]
	ensure
		@vehicle_registration_mark = params[:vehicle_registration_mark] || @car.vehicle_registration_mark
	end
	def delete_car
		params_require(:car_id)
		car = Car.find(params[:car_id])
		car.destroy if car.can_destroy
		redirect_to(action: :cars)
	end
	def conveyors
	end
	def new_conveyor
		if params_exist(:name, :store, :server_ip, :server_port)
			error('This conveyor already exist') if Conveyor.find_by_name(params[:name])
			Conveyor.create!(name: params[:name], store_id: params[:store], server_ip: params[:server_ip], server_port: params[:server_port], passive: params_exist(:passive_connection))
			redirect_to(action: :conveyors)
		end
	rescue Error
		@error_message = [$!.message]
		@name = params[:name]
		@store = params[:store]
		@server_ip = params[:server_ip]
		@server_port = params[:server_port]
		@passive_connection = params_exist(:passive_connection)
	ensure
		render(template: 'admin/edit_conveyor') unless performed?
	end
	def edit_conveyor
		params_require(:conveyor_id)
		@conveyor = Conveyor.find(params[:conveyor_id])
		if params_exist(:name, :store, :server_ip, :server_port)
			@passive_connection = params_exist(:passive_connection)
			error('This conveyor already exist') if @conveyor.name != params[:name] && Conveyor.find_by_name(params[:name])
			@conveyor.name = params[:name]
			@conveyor.store_id = params[:store]
			@conveyor.server_ip = params[:server_ip]
			@conveyor.server_port = params[:server_port]
			@conveyor.passive = @passive_connection
			@conveyor.save!
			redirect_to(action: :conveyors)
		end
	rescue Error
		@error_message = [$!.message]
	ensure
		@name = params[:name] || @conveyor.name
		@store = params[:store] || @conveyor.store_id
		@server_ip = params[:server_ip] || @conveyor.server_ip
		@server_port = params[:server_port] || @conveyor.server_port
		@passive_connection ||= @conveyor.passive
	end
	def delete_conveyor
		params_require(:conveyor_id)
		conveyor = Conveyor.find(params[:conveyor_id])
		conveyor.destroy if conveyor.can_destroy
		redirect_to(action: :conveyors)
	end
	def inspect_task_plans
	end
	def new_inspect_task_plan
		if params_exist(:day, :time, :staff, :store)
			InspectTaskPlan.create!(day: params[:day], time: params[:time], staff_id: params[:staff], store_id: params[:store])
			redirect_to(action: :inspect_task_plans)
		end
	rescue Error
		@error_message = [$!.message]
		@day = params[:day]
		@time = params[:time]
		@staff = params[:staff]
		@store = params[:store]
	ensure
		render(template: 'admin/edit_inspect_task_plan') unless performed?
	end
	def edit_inspect_task_plan
		params_require(:inspect_task_plan_id)
		@inspect_task_plan = InspectTaskPlan.find(params[:inspect_task_plan_id])
		if params_exist(:day, :time, :staff, :store)
			@inspect_task_plan.day = params[:day]
			@inspect_task_plan.time = params[:time]
			@inspect_task_plan.staff_id = params[:staff]
			@inspect_task_plan.store_id = params[:store]
			@inspect_task_plan.save!
			redirect_to(action: :inspect_task_plans)
		end
	rescue Error
		@error_message = [$!.message]
	ensure
		@day = params[:day] || @inspect_task_plan.day
		@time = params[:time] || @inspect_task_plan.time.to_s(:time)
		@staff = params[:staff] || @inspect_task_plan.staff_id
		@store = params[:store] || @inspect_task_plan.store_id
	end
	def delete_inspect_task_plan
		params_require(:inspect_task_plan_id)
		InspectTaskPlan.find(params[:inspect_task_plan_id]).destroy
		redirect_to(action: :inspect_task_plans)
	end
	def transfer_task_plans
	end
	def new_transfer_task_plan
		if params_exist(:day, :time, :car, :from_type, :from_id, :to_type, :to_id, :number)
			raise(ParameterError, 'from_type') unless [Shop.to_s, Store.to_s].include?(params[:from_type])
			raise(ParameterError, 'to_type') unless [Shop.to_s, Store.to_s].include?(params[:to_type])
			from = Object.const_get(params[:from_type]).find(params[:from_id])
			to = Object.const_get(params[:to_type]).find(params[:to_id])
			TransferTaskPlan.create!(day: params[:day], time: params[:time], car_id: params[:car], from: from, to: to, number: params[:number])
			redirect_to(action: :transfer_task_plans)
		end
	rescue Error
		@error_message = [$!.message]
		@day = params[:day]
		@time = params[:time]
		@car = params[:car]
		@from_type = params[:from_type]
		@from_id = params[:from_id]
		@to_type = params[:to_type]
		@to_id = params[:to_id]
		@number = params[:number]
	ensure
		render(template: 'admin/edit_transfer_task_plan') unless performed?
	end
	def edit_transfer_task_plan
		params_require(:transfer_task_plan_id)
		@transfer_task_plan = TransferTaskPlan.find(params[:transfer_task_plan_id])
		if params_exist(:day, :time, :car, :from_type, :from_id, :to_type, :to_id, :number)
			raise(ParameterError, 'from_type') unless [Shop.to_s, Store.to_s].include?(params[:from_type])
			raise(ParameterError, 'to_type') unless [Shop.to_s, Store.to_s].include?(params[:to_type])
			from = Object.const_get(params[:from_type]).find(params[:from_id])
			to = Object.const_get(params[:to_type]).find(params[:to_id])
			@transfer_task_plan.day = params[:day]
			@transfer_task_plan.time = params[:time]
			@transfer_task_plan.car_id = params[:car]
			@transfer_task_plan.from = from
			@transfer_task_plan.to = to
			@transfer_task_plan.number = params[:number]
			@transfer_task_plan.save!
			redirect_to(action: :transfer_task_plans)
		end
	rescue Error
		@error_message = [$!.message]
	ensure
		@day = params[:day] || @transfer_task_plan.day
		@time = params[:time] || @transfer_task_plan.time.to_s(:time)
		@car = params[:car] || @transfer_task_plan.car_id
		@from_type = params[:from_type] || @transfer_task_plan.from_type
		@from_id = params[:from_id] || @transfer_task_plan.from_id
		@to_type = params[:to_type] || @transfer_task_plan.to_type
		@to_id = params[:to_id] || @transfer_task_plan.to_id
		@number = params[:number] || @transfer_task_plan.number
	end
	def delete_transfer_task_plan
		params_require(:transfer_task_plan_id)
		TransferTaskPlan.find(params[:transfer_task_plan_id]).destroy
		redirect_to(action: :transfer_task_plans)
	end
	def visit_task_plans
	end
	def new_visit_task_plan
		if params_exist(:day, :time, :car, :store, :send_receive_number, :send_number)
			VisitTaskPlan.create!(day: params[:day], time: params[:time], car_id: params[:car], store_id: params[:store], send_receive_number: params[:send_receive_number], send_number: params[:send_number])
			redirect_to(action: :visit_task_plans)
		end
	rescue Error
		@error_message = [$!.message]
		@day = params[:day]
		@time = params[:time]
		@car = params[:car]
		@store = params[:store]
		@send_receive_number = params[:send_receive_number]
		@send_number = params[:send_number]
	ensure
		render(template: 'admin/edit_visit_task_plan') unless performed?
	end
	def edit_visit_task_plan
		params_require(:visit_task_plan_id)
		@visit_task_plan = VisitTaskPlan.find(params[:visit_task_plan_id])
		if params_exist(:day, :time, :car, :store, :send_receive_number, :send_number)
			@visit_task_plan.day = params[:day]
			@visit_task_plan.time = params[:time]
			@visit_task_plan.car_id = params[:car]
			@visit_task_plan.store_id = params[:store]
			@visit_task_plan.send_receive_number = params[:send_receive_number]
			@visit_task_plan.send_number = params[:send_number]
			@visit_task_plan.save!
			redirect_to(action: :visit_task_plans)
		end
	rescue Error
		@error_message = [$!.message]
	ensure
		@day = params[:day] || @visit_task_plan.day
		@time = params[:time] || @visit_task_plan.time.to_s(:time)
		@car = params[:car] || @visit_task_plan.car_id
		@store = params[:store] || @visit_task_plan.store_id
		@send_receive_number = params[:send_receive_number] || @visit_task_plan.send_receive_number
		@send_number = params[:send_number] || @visit_task_plan.send_number
	end
	def delete_visit_task_plan
		params_require(:visit_task_plan_id)
		VisitTaskPlan.find(params[:visit_task_plan_id]).destroy
		redirect_to(action: :visit_task_plans)
	end
	private
	def check_login
		if @expired
			session.destroy
			return redirect_to(action: :login, warning_message: ['Connection expired'], page: params)
		end
		redirect_to(action: :login, warning_message: ['Please login first']) unless session[:admin]
	end
end
