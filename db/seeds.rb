# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

store_address = StoreAddress.create!(address: '18 Tsing Wun Road, Tuen Mun, New Territories', size: 40)

specify_address = SpecifyAddress.create!(address: 'Flat 1, 23/F, Heng Wan House, Tin Heng Estate, Tin Shui Wai, New Territories') # to-delete

CheckAction.create!(name: 'count')
CheckAction.create!(name: 'in')
CheckAction.create!(name: 'out')
CheckAction.create!(name: 'load')
CheckAction.create!(name: 'unload')
CheckAction.create!(name: 'receive')
CheckAction.create!(name: 'finish')

Conveyor.create!(name: 'TM IVE Conveyor', store_address: store_address, server_ip: 'it114112tm1415fyp2.redirectme.net', server_port: 8001, passive: true)
Conveyor.create!(name: 'C2', store_address: store_address, server_ip: 'localhost', server_port: 8002, passive: false) # to-delete

Permission.create!(name: 'control_conveyor')
Permission.create!(name: 'count_good')
Permission.create!(name: 'find_good')
Permission.create!(name: 'receive_good')

ShopAddress.create!(address: 'TM IVE')

Staff.create!(username: $admin_username, password: Digest::MD5.hexdigest(Digest::MD5.hexdigest($admin_password)), is_freeze: true, name: 'admin', email: 'admin@admin.admin', phone: '+00-0')
Staff.create!(username: 'staff0', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('staff0')), is_freeze: false, name:'staff0', email: 'staff0@1415fyp.com', phone: '+852-00000000', specify_addresses: [specify_address]) # to-delete
Staff.create!(username: 'staff1', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('staff1')), is_freeze: false, name:'staff1', email: 'staff1@1415fyp.com', phone: '+852-11111111', specify_addresses: [specify_address]) # to-delete
