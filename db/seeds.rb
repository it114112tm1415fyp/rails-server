shop_address = ShopAddress.create!(address: 'TM IVE')

store_address = StoreAddress.create!(address: '18 Tsing Wun Road, Tuen Mun, New Territories', size: 40)

specify_address = SpecifyAddress.create!(address: 'Flat 1, 23/F, Heng Wan House, Tin Heng Estate, Tin Shui Wai, New Territories') # to-delete

client0 = Client.create!(username: 'client0', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('client0')), is_freeze: false, name: 'client0', email: 'client0@1415fyp.tmive', phone: '+852-00000000', specify_addresses: [specify_address]) # to-delete
client1 = Client.create!(username: 'client1', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('client1')), is_freeze: false, name: 'client1', email: 'client1@1415fyp.tmive', phone: '+852-11111111', specify_addresses: [specify_address]) # to-delete

staff0 = Staff.create!(username: 'staff0', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('staff0')), is_freeze: false, name: 'staff0', email: 'staff0@1415fyp.tmive', phone: '+852-00000000', specify_addresses: [specify_address]) # to-delete
staff1 = Staff.create!(username: 'staff1', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('staff1')), is_freeze: false, name: 'staff1', email: 'staff1@1415fyp.tmive', phone: '+852-11111111', specify_addresses: [specify_address]) # to-delete

order0 = Order.create!(sender: client0, receiver: client1, staff: staff0, pay_from_receiver: true, departure: shop_address, destination: specify_address) # to-delete
order1 = Order.create!(sender: client1, receiver: client0, staff: staff0, pay_from_receiver: true, departure: specify_address, destination: shop_address) # to-delete

check_action_receive = CheckAction.create!(name: 'receive')
check_action_warehouse = CheckAction.create!(name: 'warehouse')

#

Car.create!(driver: staff0, partner: staff1, vehicle_registration_mark: '1 L0VE U')

CheckAction.create!(name: 'issue')
CheckAction.create!(name: 'inspect')
CheckAction.create!(name: 'leave')
CheckAction.create!(name: 'load')
CheckAction.create!(name: 'unload')

Conveyor.create!(name: 'TM IVE Conveyor', store_address: store_address, server_ip: 'it114112tm1415fyp2.redirectme.net', server_port: 8001, passive: true)
Conveyor.create!(name: 'Conveyor for test', store_address: store_address, server_ip: 'localhost', server_port: 8002, passive: false) # to-delete

Good.create!(order: order0, location: specify_address, last_action: check_action_receive, rfid_tag: 'AD83 1100 45CB 1D70 0E00 005E', weight: 1.2, fragile: false, flammable: true) # to-delete
Good.create!(order: order0, location: specify_address, last_action: check_action_receive, rfid_tag: 'AD83 1100 45CB 516F 0E00 0065', weight: 0.9, fragile: true, flammable: false) # to-delete
Good.create!(order: order0, location: specify_address, last_action: check_action_receive, rfid_tag: 'AD83 1100 45CC CD7E 1600 0096', weight: 2.1, fragile: true, flammable: true) # to-delete
Good.create!(order: order1, location: shop_address, last_action: check_action_warehouse, rfid_tag: 'AD83 1100 45CC E57C 1600 0099', weight: 1.5, fragile: false, flammable: false) # to-delete

Permission.create!(name: 'control_conveyor')
Permission.create!(name: 'count_good')
Permission.create!(name: 'find_good')
Permission.create!(name: 'receive_good')

Staff.create!(username: $admin_username, password: Digest::MD5.hexdigest(Digest::MD5.hexdigest($admin_password)), is_freeze: true, name: 'admin', email: 'admin@admin.admin', phone: '+00-0')
