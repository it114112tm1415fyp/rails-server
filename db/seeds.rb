require_relative('seeds_binary_data.rb')

def new_client(name, addresses)
	Client.create!(username: name, password: Digest::MD5.hexdigest(Digest::MD5.hexdigest(name)), name: name, email: "#{name}@it114112tm1415fyp.com", phone: "+852-6#{'%07d' % rand(9999999)}", specify_addresses: addresses)
end

def new_staff(name, addresses, workplace)
	Staff.create!(username: name, password: Digest::MD5.hexdigest(Digest::MD5.hexdigest(name)), name: name, email: "#{name}@it114112tm1415fyp.com", phone: "+852-6#{'%07d' % rand(9999999)}", specify_addresses: addresses, workplace: workplace)
end

admin = Admin.create!(username: $admin_username, password: Digest::MD5.hexdigest(Digest::MD5.hexdigest($admin_password)), enable: false, name: 'admin', email: 'admin@admin.admin', phone: '+00-0')

car1 = Car.create!(vehicle_registration_mark: 'EA5651')
car2 = Car.create!(vehicle_registration_mark: 'SU8463')
car3 = Car.create!(vehicle_registration_mark: 'RC8863')
car4 = Car.create!(vehicle_registration_mark: 'SD1114')
car5 = Car.create!(vehicle_registration_mark: 'UE9283')

store1 = Store.create!(name: 'Kwai Hing Store', address: 'Flat 2, 10/F,
Vanta Industrial Centre
21-33 Tai Lin Pai Rd
Kwai Hing', shelf_number: 40)
store2 = Store.create!(name: 'Kwun Tong Store', address: 'Flat A, 2/F,
Kwun Tong Industrial Centre Phase 4,
436-446 Kwun Tong Rd,
Kwun Tong', shelf_number: 40)
store3 = Store.create!(name: 'Tuen Mun Store', address: 'Flat 5, 3/F,
Luks Industrial Bldg,
4 Kin Fung Circuit,
Tuen Mun', shelf_number: 60)

region_hong_kong = Region.create!(name: 'Hong Kong', store: store1)
region_kowloon = Region.create!(name: 'Kowloon', store: store2)
region_new_territories = Region.create!(name: 'New Territories', store: store3)
region_others = Region.create!(name: 'Others', store: store3)

shop1 = Shop.create!(name: 'Fung Full Plaza Shop', address: "Shop 2, G/F.,
Fung Full Plaza,
480 King's Road,
North Point", region: region_hong_kong)
shop2 = Shop.create!(name: 'Avon Park Shop', address: 'Shop 1, G/F,
42 & 44 Main Street,
Ap Lei Chau,
Hong Kong', region: region_hong_kong)
shop3 = Shop.create!(name: 'APM Shop', address: 'Shop 1022,
APM,
418 Kwun Tong Rd,
Kwun Tong', region: region_kowloon)
shop4 = Shop.create!(name: 'Sincere Podium Shop', address: 'Shop S12, 1/F
Sincere Podium,
83 Argyle Street,
Mong Kok', region: region_kowloon)
shop5 = Shop.create!(name: 'Yue Man Centre Shop', address: 'Shop 23, G/F.
Yue Man Centre,
300 & 302 Tau Kok Road,
Kwun Tong', region: region_kowloon)
shop6 = Shop.create!(name: 'Trend Plaza Shop', address: 'Shop 0120,
Trend Plaza North Wing,
2 Tuen Lung St,
Tuen Mun', region: region_new_territories)
shop7 = Shop.create!(name: 'Kingswood Richly Plaza Shop', address: 'Shop A14, G/F,
Kingswood Richly Plaza,
1 Tin Wu Road,
Tin Shui Wai', region: region_new_territories)
shop8 = Shop.create!(name: 'Hang King Garden Shop', address: 'Shop G16, G/F,
Hang King Garden,
9 Wing Fong Road,
Kwai Fong', region: region_new_territories)
shop9 = Shop.create!(name: 'Heng On Shopping Centre Shop', address: 'Shop 317, 3/F,
Heng On Shopping Centre,
Heng On Estate,
Ma On Shan', region: region_new_territories)

specify_address1 = SpecifyAddress.create!(address: 'Flat 1, 23/F, Heng Wan House,
Tin Heng Estate,
Tin Shui Wai', region: region_new_territories)
specify_address2 = SpecifyAddress.create!(address: 'Flat 3, Floor 10, Block D,
Galaxia,
Diamond Hill', region: region_kowloon)
specify_address3 = SpecifyAddress.create!(address: 'Flat A, Floor 43,
Highcliff,
The Peak', region: region_hong_kong)
specify_address4 = SpecifyAddress.create!(address: 'Floor 1, Block 20,
Tinford Garden,
Cheung Chau', region: region_others)
specify_address5 = SpecifyAddress.create!(address: 'Flat 2, 21/F, Heng Wan House,
Tin Heng Estate,
Tin Shui Wai', region: region_new_territories)
specify_address6 = SpecifyAddress.create!(address: 'Flat 5, Floor 20, Block D,
Galaxia,
Diamond Hill', region: region_kowloon)
specify_address7 = SpecifyAddress.create!(address: 'Flat B, Floor 32,
Highcliff,
The Peak', region: region_hong_kong)
specify_address8 = SpecifyAddress.create!(address: 'Floor 1, Block 3,
Tinford Garden,
Cheung Chau', region: region_others)
specify_address9 = SpecifyAddress.create!(address: 'Flat 3, 4/F, Heng Wan House,
Tin Heng Estate,
Tin Shui Wai', region: region_new_territories)
specify_address10 = SpecifyAddress.create!(address: 'Flat 2, Floor 3, Block D,
Galaxia,
Diamond Hill', region: region_kowloon)
specify_address11 = SpecifyAddress.create!(address: 'Flat D, Floor 13,
Highcliff,
The Peak', region: region_hong_kong)
specify_address12 = SpecifyAddress.create!(address: 'Floor 1, Block 4,
Tinford Garden,
Cheung Chau', region: region_others)
specify_address13 = SpecifyAddress.create!(address: 'Flat 4, 1/F, Heng Wan House,
Tin Heng Estate,
Tin Shui Wai', region: region_new_territories)

conveyor1 = Conveyor.create!(name: 'TM IVE Conveyor', store: store3, server_ip: 'it114112tm1415fyp2.redirectme.net', server_port: 8001, passive: true)
conveyor2 = Conveyor.create!(name: 'Conveyor for test', store: store2, server_ip: 'localhost', server_port: 8002, passive: false)

client1 = new_client('john0', [specify_address10])
client2 = new_client('tomas', [specify_address11])

staff1 = new_staff('alisa', [specify_address1], car1)
staff2 = new_staff('camille', [specify_address2], car2)
staff3 = new_staff('donna', [specify_address3], car3)
staff4 = new_staff('elsa0', [specify_address4], car4)
staff5 = new_staff('fannie', [specify_address5], car5)
staff6 = new_staff('jennifer', [specify_address6], store1)
staff7 = new_staff('kelly', [specify_address7], store2)
staff8 = new_staff('lance', [specify_address8], store3)
staff9 = new_staff('mark0', [specify_address9], shop1)
staff10 = new_staff('oscar', [specify_address10], shop2)
staff11 = new_staff('peter', [specify_address11], shop3)
staff12 = new_staff('quentin', [specify_address12], shop4)
staff13 = new_staff('terence', [specify_address13], shop5)
staff14 = new_staff('apple', [specify_address1], shop6)
staff15 = new_staff('david', [specify_address2], shop7)
staff16 = new_staff('paul0', [specify_address3], shop8)
staff17 = new_staff('steven', [specify_address4], shop9)
staff18 = new_staff('jeff0', [specify_address5], store1)
staff19 = new_staff('dorothy', [specify_address6], store2)
staff20 = new_staff('carol', [specify_address7], store3)
staff21 = new_staff('lisa0', [specify_address8], shop2)
staff22 = new_staff('helen', [specify_address9], shop7)

InspectTaskPlan.create!(day: 0b1111111, time: Time.new(2000,1,1,0), staff: staff6, store: store1)
InspectTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,10), staff: staff6, store: store1)
InspectTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,10), staff: staff7, store: store2)
InspectTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,10), staff: staff8, store: store3)

TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,10), car: car1, from: store1, to: store2, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,13), car: car1, from: store2, to: store3, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,15), car: car1, from: store3, to: store1, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,10), car: car2, from: store3, to: store2, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,13), car: car2, from: store2, to: store1, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,15), car: car2, from: store1, to: store3, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,11), car: car3, from: store1, to: shop1, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,11,30), car: car3, from: shop1, to: store1, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,13), car: car3, from: store1, to: shop2, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,13,30), car: car3, from: shop2, to: store1, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,11), car: car4, from: store2, to: shop3, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,11,30), car: car4, from: shop3, to: store2, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,13), car: car4, from: store2, to: shop4, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,13,30), car: car4, from: shop4, to: store2, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,14), car: car4, from: store2, to: shop5, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,14,30), car: car4, from: shop5, to: store2, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,11), car: car5, from: store3, to: shop6, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,11,30), car: car5, from: shop6, to: store3, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,13), car: car5, from: store3, to: shop7, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,13,30), car: car5, from: shop7, to: store3, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,14), car: car5, from: store3, to: shop8, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,14,30), car: car5, from: shop8, to: store3, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,15), car: car5, from: store3, to: shop9, number: 30)
TransferTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,15,30), car: car5, from: shop9, to: store3, number: 30)

VisitTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,10), car: car3, store: store1, send_receive_number: 3, send_number: 2)
VisitTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,14,30), car: car3, store: store1, send_receive_number: 5, send_number: 3)
VisitTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,16), car: car3, store: store1, send_receive_number: 8, send_number: 5)
VisitTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,10), car: car4, store: store2, send_receive_number: 3, send_number: 2)
VisitTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,15), car: car4, store: store2, send_receive_number: 3, send_number: 2)
VisitTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,16), car: car4, store: store2, send_receive_number: 9, send_number: 6)
VisitTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,10), car: car5, store: store3, send_receive_number: 2, send_number: 1)
VisitTaskPlan.create!(day: 0b1111110, time: Time.new(2000,1,1,16), car: car5, store: store3, send_receive_number: 6, send_number: 4)

order_state_canceled = OrderState.create!(name: 'canceled')
order_state_confirmed = OrderState.create!(name: 'confirmed')
order_state_sending = OrderState.create!(name: 'sending')
order_state_sent = OrderState.create!(name: 'sent')
order_state_submitted = OrderState.create!(name: 'submitted')

check_action_inspect = CheckAction.create!(name: 'inspect')
check_action_issue = CheckAction.create!(name: 'issue')
check_action_leave = CheckAction.create!(name: 'leave')
check_action_load = CheckAction.create!(name: 'load')
check_action_receive = CheckAction.create!(name: 'receive')
check_action_unload = CheckAction.create!(name: 'unload')
check_action_warehouse = CheckAction.create!(name: 'warehouse')

order1 = Order.create!(sender: staff1, sender_sign: '', receiver: staff2, goods_number: 1, departure: specify_address1, destination: specify_address2, order_state: order_state_submitted)
order2 = Order.create!(sender: staff1, sender_sign: '', receiver: staff3, goods_number: 1, departure: shop1, destination: specify_address3, order_state: order_state_confirmed)
order3 = Order.create!(sender: staff1, sender_sign: '', receiver: staff4, goods_number: 2, departure: specify_address3, destination: shop6, order_state: order_state_sending)
order4 = Order.create!(sender: staff1, sender_sign: '', receiver: staff5, goods_number: 1, departure: shop2, destination: specify_address5, order_state: order_state_sent)
order5 = Order.create!(sender: staff1, sender_sign: '', receiver: staff6, goods_number: 2, departure: specify_address5, destination: specify_address6, order_state: order_state_canceled)
order6 = Order.create!(sender: staff1, sender_sign: '', receiver: staff7, goods_number: 1, departure: shop3, destination: shop7, order_state: order_state_submitted)
order7 = Order.create!(sender: staff1, sender_sign: '', receiver: staff8, goods_number: 1, departure: specify_address7, destination: specify_address8, order_state: order_state_confirmed)
order8 = Order.create!(sender: staff1, sender_sign: '', receiver: staff9, goods_number: 1, departure: shop4, destination: specify_address9, order_state: order_state_sending)
order9 = Order.create!(sender: staff1, sender_sign: '', receiver: staff10, goods_number: 2, departure: specify_address9, destination: shop8, order_state: order_state_sent)
order10 = Order.create!(sender: staff1, sender_sign: '', receiver: staff11, goods_number: 2, departure: shop5, destination: specify_address11, order_state: order_state_canceled)
order11 = Order.create!(sender: staff12, sender_sign: '', receiver: staff1, goods_number: 3, departure: specify_address11, destination: specify_address12, order_state: order_state_submitted)

goods1 = Goods.create!(order: order3, string_id: '33pc1z', location: store1, shelf_id: 1, staff: staff6, last_action: check_action_inspect, rfid_tag: 'AD83 1100 45CB 1D70 0E00 005E', weight: 1.2, fragile: false, flammable: true, goods_photo: @goods_photo)
goods2 = Goods.create!(order: order3, string_id: 'ejqd5e', location: store1, shelf_id: 1, staff: staff6, last_action: check_action_inspect, rfid_tag: 'AD83 1100 45CB 516F 0E00 0065', weight: 0.9, fragile: true, flammable: false, goods_photo: @goods_photo)
goods3 = Goods.create!(order: order8, string_id: 'h0bw54', location: shop4, staff: staff12, last_action: check_action_receive, rfid_tag: 'AD83 1100 45CC E57C 1600 0099', weight: 1.5, fragile: false, flammable: false, goods_photo: @goods_photo)
goods4 = Goods.create!(order: order4, string_id: '28hd3l', location: specify_address5, staff: staff1, last_action: check_action_issue, rfid_tag: '0000 0000 0000 0000 0000 0001', weight: 2.1, fragile: false, flammable: false, goods_photo: @goods_photo)
goods5 = Goods.create!(order: order9, string_id: '5hs6rw', location: shop8, staff: staff16, last_action: check_action_issue, rfid_tag: '0000 0000 0000 0000 0000 0002', weight: 3.1, fragile: true, flammable: false, goods_photo: @goods_photo)
goods6 = Goods.create!(order: order9, string_id: '8gek4f', location: shop8, staff: staff16, last_action: check_action_issue, rfid_tag: '0000 0000 0000 0000 0000 0003', weight: 2.7, fragile: false, flammable: false, goods_photo: @goods_photo)

CheckLog.create!(time: Time.now + 1, goods: goods1, location: specify_address3, check_action: check_action_receive, staff: staff3)
CheckLog.create!(time: Time.now + 2, goods: goods1, location: car3, check_action: check_action_load, staff: staff3)
CheckLog.create!(time: Time.now + 3, goods: goods1, location: car3, check_action: check_action_unload, staff: staff3)
CheckLog.create!(time: Time.now + 4, goods: goods1, location: store1, check_action: check_action_warehouse, staff: staff6)
CheckLog.create!(time: Time.now + 5, goods: goods1, location: store1, check_action: check_action_inspect, staff: staff6)
CheckLog.create!(time: Time.now + 1, goods: goods2, location: specify_address3, check_action: check_action_receive, staff: staff3)
CheckLog.create!(time: Time.now + 2, goods: goods2, location: car3, check_action: check_action_load, staff: staff3)
CheckLog.create!(time: Time.now + 3, goods: goods2, location: car3, check_action: check_action_unload, staff: staff3)
CheckLog.create!(time: Time.now + 4, goods: goods2, location: store1, check_action: check_action_warehouse, staff: staff6)
CheckLog.create!(time: Time.now + 5, goods: goods2, location: store1, check_action: check_action_inspect, staff: staff6)
CheckLog.create!(time: Time.now + 1, goods: goods3, location: shop4, check_action: check_action_receive, staff: staff12)
CheckLog.create!(time: Time.now + 1, goods: goods4, location: shop2, check_action: check_action_receive, staff: staff10)
CheckLog.create!(time: Time.now + 2, goods: goods4, location: shop2, check_action: check_action_leave, staff: staff10)
CheckLog.create!(time: Time.now + 3, goods: goods4, location: car3, check_action: check_action_load, staff: staff3)
CheckLog.create!(time: Time.now + 4, goods: goods4, location: car3, check_action: check_action_unload, staff: staff3)
CheckLog.create!(time: Time.now + 5, goods: goods4, location: store1, check_action: check_action_warehouse, staff: staff6)
CheckLog.create!(time: Time.now + 6, goods: goods4, location: store1, check_action: check_action_inspect, staff: staff6)
CheckLog.create!(time: Time.now + 7, goods: goods4, location: store1, check_action: check_action_inspect, staff: staff6)
CheckLog.create!(time: Time.now + 8, goods: goods4, location: store1, check_action: check_action_leave, staff: staff6)
CheckLog.create!(time: Time.now + 9, goods: goods4, location: car2, check_action: check_action_load, staff: staff2)
CheckLog.create!(time: Time.now + 10, goods: goods4, location: car2, check_action: check_action_unload, staff: staff2)
CheckLog.create!(time: Time.now + 11, goods: goods4, location: store3, check_action: check_action_warehouse, staff: staff8)
CheckLog.create!(time: Time.now + 12, goods: goods4, location: store3, check_action: check_action_inspect, staff: staff8)
CheckLog.create!(time: Time.now + 13, goods: goods4, location: store3, check_action: check_action_leave, staff: staff8)
CheckLog.create!(time: Time.now + 14, goods: goods4, location: car5, check_action: check_action_load, staff: staff5)
CheckLog.create!(time: Time.now + 15, goods: goods4, location: car5, check_action: check_action_unload, staff: staff5)
CheckLog.create!(time: Time.now + 16, goods: goods4, location: specify_address5, check_action: check_action_receive, staff: staff5)
CheckLog.create!(time: Time.now + 1, goods: goods5, location: specify_address9, check_action: check_action_receive, staff: staff5)
CheckLog.create!(time: Time.now + 2, goods: goods5, location: car5, check_action: check_action_load, staff: staff5)
CheckLog.create!(time: Time.now + 3, goods: goods5, location: car5, check_action: check_action_unload, staff: staff5)
CheckLog.create!(time: Time.now + 4, goods: goods5, location: store3, check_action: check_action_warehouse, staff: staff8)
CheckLog.create!(time: Time.now + 5, goods: goods5, location: store3, check_action: check_action_inspect, staff: staff8)
CheckLog.create!(time: Time.now + 6, goods: goods5, location: store3, check_action: check_action_leave, staff: staff8)
CheckLog.create!(time: Time.now + 7, goods: goods5, location: car5, check_action: check_action_load, staff: staff5)
CheckLog.create!(time: Time.now + 8, goods: goods5, location: car5, check_action: check_action_unload, staff: staff5)
CheckLog.create!(time: Time.now + 9, goods: goods5, location: shop8, check_action: check_action_warehouse, staff: staff16)
CheckLog.create!(time: Time.now + 10, goods: goods5, location: shop8, check_action: check_action_issue, staff: staff16)
CheckLog.create!(time: Time.now + 1, goods: goods6, location: specify_address9, check_action: check_action_receive, staff: staff5)
CheckLog.create!(time: Time.now + 2, goods: goods6, location: car5, check_action: check_action_load, staff: staff5)
CheckLog.create!(time: Time.now + 3, goods: goods6, location: car5, check_action: check_action_unload, staff: staff5)
CheckLog.create!(time: Time.now + 4, goods: goods6, location: store3, check_action: check_action_warehouse, staff: staff8)
CheckLog.create!(time: Time.now + 5, goods: goods6, location: store3, check_action: check_action_inspect, staff: staff8)
CheckLog.create!(time: Time.now + 6, goods: goods6, location: store3, check_action: check_action_leave, staff: staff8)
CheckLog.create!(time: Time.now + 7, goods: goods6, location: car5, check_action: check_action_load, staff: staff5)
CheckLog.create!(time: Time.now + 8, goods: goods6, location: car5, check_action: check_action_unload, staff: staff5)
CheckLog.create!(time: Time.now + 9, goods: goods6, location: shop8, check_action: check_action_warehouse, staff: staff16)
CheckLog.create!(time: Time.now + 10, goods: goods6, location: shop8, check_action: check_action_issue, staff: staff16)
