Admin.create!(username: $admin_username, password: Digest::MD5.hexdigest(Digest::MD5.hexdigest($admin_password)), enable: false, name: 'admin', email: 'admin@admin.admin', phone: '+00-0')

car1 = Car.create!(vehicle_registration_mark: 'EA5651')
car2 = Car.create!(vehicle_registration_mark: 'SU8463')
car3 = Car.create!(vehicle_registration_mark: 'RC8863')

store1 = Store.create!(name: 'Tuen Mun Store', address: 'Flat 5, 3/F,
Luks Industrial Bldg,
4 Kin Fung Circuit,
Tuen Mun', size: 40)
store2 = Store.create!(name: 'Kwun Tong Store', address: 'Flat A, 2/F,
Kwun Tong Industrial Centre Phase 4,
436-446 Kwun Tong Rd,
Kwun Tong', size: 40)
store3 = Store.create!(name: 'Kwai Hing Store', address: 'Flat 2, 10/F,
Vanta Industrial Centre
21-33 Tai Lin Pai Rd
Kwai Hing', size: 40)

region1 = Region.create!(name: 'Hong Kong', store: store3)
region2 = Region.create!(name: 'Kowloon', store: store2)
region3 = Region.create!(name: 'New Territories', store: store1)
region4 = Region.create!(name: 'Others', store: store2)

shop1 = Shop.create!(name: 'Trend Plaza Shop', address: 'Shop 0120,
Trend Plaza North Wing,
2 Tuen Lung St,
Tuen Mun', region: region3)
shop2 = Shop.create!(name: 'APM Shop', address: 'Shop 1022,
APM,
418 Kwun Tong Rd,
Kwun Tong', region: region2)

specify_address = SpecifyAddress.create!(address: 'Flat 1, 23/F, Heng Wan House,
Tin Heng Estate,
Tin Shui Wai', region:region3)

staff1 = Staff.create!(username: 'hoyuensan', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('hoyuensan')), name: 'Ho Yuen San', email: 'hoyuensan@yahoo.com', phone: '+852-94341735', specify_addresses: [specify_address], workplace: store1)
staff2 = Staff.create!(username: 'likinlun', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('likinlun')), name: 'Li Lin Lun', email: 'likinlun@yahoo.com.hk', phone: '+852-68376283', specify_addresses: [specify_address], workplace: store2)
staff3 = Staff.create!(username: 'lokifung', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('lokifung')), name: 'Lo Ki Fung', email: 'lokifung@yahoo.com.hk', phone: '+852-94464303', specify_addresses: [specify_address], workplace: shop1)
staff4 = Staff.create!(username: 'lukwai', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('lukwai')), name: 'Luk Wai', email: 'lukwai@yahoo.com', phone: '+852-63884811', specify_addresses: [specify_address], workplace: car1)

order_state_after_contact = OrderState.create!(name: 'after_contact')
order_state_canceled = OrderState.create!(name: 'canceled')
order_state_sending = OrderState.create!(name: 'sending')
order_state_sent = OrderState.create!(name: 'sent')
order_state_submitted = OrderState.create!(name: 'submitted')

order1 = Order.create!(sender: staff3, sender_sign: '', receiver: staff4, goods_number: 2, departure: shop1, destination: specify_address, order_state: order_state_sending)
order2 = Order.create!(sender: staff4, sender_sign: '', receiver: staff3, goods_number: 1, departure: specify_address, destination: shop2, order_state: order_state_sending)

check_action_receive = CheckAction.create!(name: 'receive')
check_action_warehouse = CheckAction.create!(name: 'warehouse')
check_action_leave = CheckAction.create!(name: 'leave')
check_action_load = CheckAction.create!(name: 'load')

good1 = Good.create!(order: order1, string_id: '33pc1z', location: specify_address, staff: staff1, last_action: check_action_load, rfid_tag: 'AD83 1100 45CB 1D70 0E00 005E', weight: 1.2, fragile: false, flammable: true, picture: '')
good2 = Good.create!(order: order1, string_id: 'ejqd5e', location: specify_address, staff: staff1, last_action: check_action_load, rfid_tag: 'AD83 1100 45CB 516F 0E00 0065', weight: 0.9, fragile: true, flammable: false, picture: '')
good3 = Good.create!(order: order2, string_id: 'h0bw54', location: shop1, staff: staff1, last_action: check_action_receive, rfid_tag: 'AD83 1100 45CC E57C 1600 0099', weight: 1.5, fragile: false, flammable: false, picture: '')

#

CheckAction.create!(name: 'issue')
CheckAction.create!(name: 'inspect')
CheckAction.create!(name: 'unload')

Conveyor.create!(name: 'TM IVE Conveyor', store: store1, server_ip: 'it114112tm1415fyp2.redirectme.net', server_port: 8001, passive: true)
Conveyor.create!(name: 'Conveyor for test', store: store2, server_ip: 'localhost', server_port: 8002, passive: false)

CheckLog.create!(time: Time.now, good: good1, location: shop1, check_action: check_action_receive, staff: staff1)
CheckLog.create!(time: Time.now, good: good1, location: shop1, check_action: check_action_leave, staff: staff2)
CheckLog.create!(time: Time.now, good: good1, location: car1, check_action: check_action_load, staff: staff2)
CheckLog.create!(time: Time.now, good: good2, location: shop1, check_action: check_action_receive, staff: staff1)
CheckLog.create!(time: Time.now, good: good2, location: shop1, check_action: check_action_leave, staff: staff2)
CheckLog.create!(time: Time.now, good: good2, location: car1, check_action: check_action_load, staff: staff2)
CheckLog.create!(time: Time.now, good: good3, location: shop2, check_action: check_action_receive, staff: staff2)

Permission.create!(name: 'control_conveyor')
Permission.create!(name: 'count_good')
Permission.create!(name: 'find_good')
Permission.create!(name: 'receive_good')

## delete this when demo

Client.create!(username: 'client0', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('client0')), name: 'client0', email: 'client0@client0.client', phone: '+852-00000000', specify_addresses: [specify_address])
Client.create!(username: 'client1', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('client1')), name: 'client1', email: 'client1@client1.client', phone: '+852-11111111', specify_addresses: [specify_address])
Staff.create!(username: 'staff0', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('staff0')), name: 'staff0', email: 'staff0@staff0.staff', phone: '+852-00000000', specify_addresses: [specify_address], workplace: car2)
Staff.create!(username: 'staff1', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('staff1')), name: 'staff1', email: 'staff1@staff1.staff', phone: '+852-11111111', specify_addresses: [specify_address], workplace: car2)
