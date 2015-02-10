Admin.create!(username: $admin_username, password: Digest::MD5.hexdigest(Digest::MD5.hexdigest($admin_password)), is_freeze: true, name: 'admin', email: 'admin@admin.admin', phone: '+00-0')

car1 = Car.create!(vehicle_registration_mark: '1 L0VE U')
car2 = Car.create!(vehicle_registration_mark: 'SU8463')
car3 = Car.create!(vehicle_registration_mark: 'RC8863')

store1 = Store.create!(address: 'Flat 5, 3/F,
Luks Industrial Bldg,
4 Kin Fung Circuit,
Tuen Mun', size: 40)
store2 = Store.create!(address: 'Flat A, 2/F,
Kwun Tong Industrial Centre Phase 4,
436-446 Kwun Tong Rd,
Kwun Tong', size: 40)
store3 = Store.create!(address: 'Flat 2, 10/F,
Vanta Industrial Centre
21-33 Tai Lin Pai Rd
Kwai Hing', size: 40)

region1 = Region.create!(name: 'Hong Kong', store: store3)
region2 = Region.create!(name: 'Kowloon', store: store2)
region3 = Region.create!(name: 'New Territories', store: store1)
region4 = Region.create!(name: 'Others', store: store2)

shop1 = Shop.create!(address: 'Shop 0120,
Trend Plaza North Wing,
2 Tuen Lung St,
Tuen Mun', region: region3)
shop2 = Shop.create!(address: 'Shop 1022,
APM,
418 Kwun Tong Rd,
Kwun Tong', region: region2)

specify_address = SpecifyAddress.create!(address: 'Flat 1, 23/F, Heng Wan House,
Tin Heng Estate,
Tin Shui Wai', region:region3)

staff1 = Staff.create!(username: 'hoyuensan', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('hoyuensan')), is_freeze: false, name: 'Ho Yuen San', email: 'hoyuensan@yahoo.com', phone: '+852-94341735', specify_addresses: [specify_address], car: car2, driver: false)
staff2 = Staff.create!(username: 'likinlun', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('likinlun')), is_freeze: false, name: 'Li Lin Lun', email: 'likinlun@yahoo.com.hk', phone: '+852-68376283', specify_addresses: [specify_address], car: car2, driver: true)
staff3 = Staff.create!(username: 'lokifung', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('lokifung')), is_freeze: false, name: 'Lo Ki Fung', email: 'lokifung@yahoo.com.hk', phone: '+852-94464303', specify_addresses: [specify_address])
staff4 = Staff.create!(username: 'lukwai', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('lukwai')), is_freeze: false, name: 'Luk Wai', email: 'lukwai@yahoo.com', phone: '+852-63884811', specify_addresses: [specify_address])

order0 = Order.create!(sender: staff3, receiver: staff4, staff: staff1, pay_from_receiver: true, departure: shop1, destination: specify_address)
order1 = Order.create!(sender: staff4, receiver: staff3, staff: staff2, pay_from_receiver: true, departure: specify_address, destination: shop2)

check_action_receive = CheckAction.create!(name: 'receive')
check_action_warehouse = CheckAction.create!(name: 'warehouse')
check_action_leave = CheckAction.create!(name: 'leave')
check_action_load = CheckAction.create!(name: 'load')

#

CheckAction.create!(name: 'issue')
CheckAction.create!(name: 'inspect')
CheckAction.create!(name: 'unload')

Conveyor.create!(name: 'TM IVE Conveyor', store: store1, server_ip: 'it114112tm1415fyp2.redirectme.net', server_port: 8001, passive: true)
Conveyor.create!(name: 'Conveyor for test', store: store2, server_ip: 'localhost', server_port: 8002, passive: false)

Good.create!(order: order0, location: specify_address, last_action: check_action_load, rfid_tag: 'AD83 1100 45CB 1D70 0E00 005E', weight: 1.2, fragile: false, flammable: true)
Good.create!(order: order0, location: specify_address, last_action: check_action_load, rfid_tag: 'AD83 1100 45CB 516F 0E00 0065', weight: 0.9, fragile: true, flammable: false)
Good.create!(order: order0, location: specify_address, last_action: check_action_load, rfid_tag: 'AD83 1100 45CC CD7E 1600 0096', weight: 2.1, fragile: true, flammable: true)
Good.create!(order: order1, location: shop1, last_action: check_action_receive, rfid_tag: 'AD83 1100 45CC E57C 1600 0099', weight: 1.5, fragile: false, flammable: false)

CheckLog.create!(time: Time.now, good_id: 1, location: shop1, check_action: check_action_receive, staff: staff1)
CheckLog.create!(time: Time.now, good_id: 1, location: shop1, check_action: check_action_leave, staff: staff2)
CheckLog.create!(time: Time.now, good_id: 1, location: car1, check_action: check_action_load, staff: staff2)
CheckLog.create!(time: Time.now, good_id: 2, location: shop1, check_action: check_action_receive, staff: staff1)
CheckLog.create!(time: Time.now, good_id: 2, location: shop1, check_action: check_action_leave, staff: staff2)
CheckLog.create!(time: Time.now, good_id: 2, location: car1, check_action: check_action_load, staff: staff2)
CheckLog.create!(time: Time.now, good_id: 3, location: shop1, check_action: check_action_receive, staff: staff1)
CheckLog.create!(time: Time.now, good_id: 3, location: shop1, check_action: check_action_leave, staff: staff2)
CheckLog.create!(time: Time.now, good_id: 3, location: car1, check_action: check_action_load, staff: staff2)

CheckLog.create!(time: Time.now, good_id: 4, location: shop2, check_action: check_action_receive, staff: staff2)

Permission.create!(name: 'control_conveyor')
Permission.create!(name: 'count_good')
Permission.create!(name: 'find_good')
Permission.create!(name: 'receive_good')

## delete this when demo

Client.create!(username: 'client0', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('client0')), is_freeze: false, name: 'client0', email: 'client0@client0.client', phone: '+852-00000000', specify_addresses: [specify_address])
Client.create!(username: 'client1', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('client1')), is_freeze: false, name: 'client1', email: 'client1@client1.client', phone: '+852-11111111', specify_addresses: [specify_address])
Staff.create!(username: 'staff0', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('staff0')), is_freeze: false, name: 'staff0', email: 'staff0@staff0.staff', phone: '+852-00000000', specify_addresses: [specify_address])
Staff.create!(username: 'staff1', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('staff1')), is_freeze: false, name: 'staff1', email: 'staff1@staff1.staff', phone: '+852-11111111', specify_addresses: [specify_address])
