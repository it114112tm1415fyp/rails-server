store_address = StoreAddress.create!(address: '18 Tsing Wun Road, Tuen Mun, New Territories', size: 40)

specify_address = SpecifyAddress.create!(address: 'Flat 1, 23/F, Heng Wan House, Tin Heng Estate, Tin Shui Wai, New Territories') # to-delete

CheckAction.create!(name: 'inspect')
CheckAction.create!(name: 'warehouse')
CheckAction.create!(name: 'leave')
CheckAction.create!(name: 'load')
CheckAction.create!(name: 'unload')
CheckAction.create!(name: 'receive')
CheckAction.create!(name: 'issue')

Client.create!(username: 'client0', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('client0')), is_freeze: false, name: 'client0', email: 'client0@1415fyp.tmive', phone: '+852-00000000', specify_addresses: [specify_address]) # to-delete
Client.create!(username: 'client1', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('client1')), is_freeze: false, name: 'client1', email: 'client1@1415fyp.tmive', phone: '+852-11111111', specify_addresses: [specify_address]) # to-delete

Conveyor.create!(name: 'TM IVE Conveyor', store_address: store_address, server_ip: 'it114112tm1415fyp2.redirectme.net', server_port: 8001, passive: true)
Conveyor.create!(name: 'Conveyor for test', store_address: store_address, server_ip: 'localhost', server_port: 8002, passive: false) # to-delete

Permission.create!(name: 'control_conveyor')
Permission.create!(name: 'count_good')
Permission.create!(name: 'find_good')
Permission.create!(name: 'receive_good')

ShopAddress.create!(address: 'TM IVE')

Staff.create!(username: $admin_username, password: Digest::MD5.hexdigest(Digest::MD5.hexdigest($admin_password)), is_freeze: true, name: 'admin', email: 'admin@admin.admin', phone: '+00-0')
Staff.create!(username: 'staff0', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('staff0')), is_freeze: false, name: 'staff0', email: 'staff0@1415fyp.tmive', phone: '+852-00000000', specify_addresses: [specify_address]) # to-delete
Staff.create!(username: 'staff1', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('staff1')), is_freeze: false, name: 'staff1', email: 'staff1@1415fyp.tmive', phone: '+852-11111111', specify_addresses: [specify_address]) # to-delete
