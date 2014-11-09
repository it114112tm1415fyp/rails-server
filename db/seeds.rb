# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

AddressType.create!(name: 'shipping', has_size: false, is_unique: true)
AddressType.create!(name: 'store', has_size: true)
AddressType.create!(name: 'shop', has_size: true)
AddressType.create!(name: 'specify', has_size: false)

Address.create!(address: '--', address_type_id: 1)
Address.create!(address: 'TM IVE', address_type_id: 2, size: 40)

CheckAction.create!(name: 'count')
CheckAction.create!(name: 'in')
CheckAction.create!(name: 'out')
CheckAction.create!(name: 'load')
CheckAction.create!(name: 'unload')
CheckAction.create!(name: 'receive')
CheckAction.create!(name: 'finish')

Conveyor.create!(name: 'TM IVE Conveyor', location_id: 2, server_ip: 'it114112tm1415fyp2.redirectme.net', server_port: 8001, passive: true)

UserType.create!(name: 'admin', is_unique: true)
UserType.create!(name: 'temp', can_login: false)
UserType.create!(name: 'staff')
UserType.create!(name: 'client')

Permission.create!(name: 'control_conveyor')
Permission.create!(name: 'count_good')
Permission.create!(name: 'find_good')
Permission.create!(name: 'receive_good')

User.create!(username: 'admin', password: Digest::MD5.hexdigest(Digest::MD5.hexdigest('admin')), is_freeze: false, name: 'admin', email: 'admin@system.com', phone: '+852-00000000', user_type_id: 1)
