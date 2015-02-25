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
	def shops
	end
	def stores
	end
	def conveyors
	end
	def cars
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
		raise(ParameterError, 'object_type') unless [Car.to_s, RegisteredUser.to_s, Shop.to_s, Store.to_s].include?(params[:object_type])
		object = Object.const_get(params[:object_type]).find(params[:object_id])
		object.enable = !object.enable
		object.save!
		redirect_to(action: params[:redirect])
	end
	def new_staff_account
		if params_exist(:username, :password, :name, :email, :phone, :addresses)
			Staff.register(params[:username], params[:password], params[:name], params[:email], params[:phone], params_exist(:enable), params[:addresses])
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
		@enable = params_exist(:enable)
		@addresses = params[:addresses]
	ensure
		render(template: 'admin/edit_account') unless performed?
	end
	def edit_account
		params_require(:account_id)
		@account = RegisteredUser.find(params[:account_id])
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
		@enable ||= @account.enable
		@addresses = params[:addresses] || @account.specify_addresses.collect { |x| {address: x.address, region: x.region.id.to_s} }
	end
	def delete_account
		params_require(:account_id)
		account = RegisteredUser.find(params[:account_id])
		account.destroy if account.can_destroy
		redirect_to(action: account.type.downcase + '_accounts')
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
		Car.find(params[:car_id]).destroy
		redirect_to(action: :cars)
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
		@region = params[:region] || @shop.region.id.to_s
	end
	def delete_shop
		params_require(:shop_id)
		shop = Shop.find(params[:shop_id])
		shop.destroy if shop.can_destroy
		redirect_to(action: :shops)
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
	private
	def check_login
		if @expired
			session.destroy
			return redirect_to(action: :login, warning_message: ['Connection expired'], page: params)
		end
		redirect_to(action: :login, warning_message: ['Please login first']) unless session[:admin]
	end
end
