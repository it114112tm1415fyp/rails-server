# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 1) do

  create_table "cars", force: :cascade do |t|
    t.string "vehicle_registration_mark", limit: 8, null: false
  end

  add_index "cars", ["vehicle_registration_mark"], name: "index_cars_on_vehicle_registration_mark", unique: true, using: :btree

  create_table "check_actions", force: :cascade do |t|
    t.string "name", limit: 255, null: false
  end

  add_index "check_actions", ["name"], name: "index_check_actions_on_name", unique: true, using: :btree

  create_table "check_logs", id: false, force: :cascade do |t|
    t.datetime "time",                        null: false
    t.integer  "good_id",         limit: 4,   null: false
    t.integer  "location_id",     limit: 4,   null: false
    t.string   "location_type",   limit: 255, null: false
    t.integer  "check_action_id", limit: 4,   null: false
    t.integer  "staff_id",        limit: 4,   null: false
  end

  add_index "check_logs", ["check_action_id"], name: "check_action_id", using: :btree
  add_index "check_logs", ["good_id"], name: "good_id", using: :btree
  add_index "check_logs", ["staff_id"], name: "staff_id", using: :btree

  create_table "conveyor_control_logs", id: false, force: :cascade do |t|
    t.integer  "staff_id",    limit: 4,   null: false
    t.integer  "conveyor_id", limit: 4,   null: false
    t.string   "message",     limit: 255, null: false
    t.datetime "time",                    null: false
  end

  add_index "conveyor_control_logs", ["conveyor_id"], name: "conveyor_id", using: :btree
  add_index "conveyor_control_logs", ["staff_id"], name: "staff_id", using: :btree

  create_table "conveyors", force: :cascade do |t|
    t.string  "name",        limit: 40,  null: false
    t.integer "store_id",    limit: 4,   null: false
    t.string  "server_ip",   limit: 255, null: false
    t.integer "server_port", limit: 8,   null: false
    t.boolean "passive",     limit: 1,   null: false
  end

  add_index "conveyors", ["name"], name: "index_conveyors_on_name", unique: true, using: :btree
  add_index "conveyors", ["store_id"], name: "store_id", using: :btree

  create_table "goods", force: :cascade do |t|
    t.integer  "order_id",       limit: 4,   null: false
    t.integer  "location_id",    limit: 4,   null: false
    t.string   "location_type",  limit: 255, null: false
    t.integer  "last_action_id", limit: 4,   null: false
    t.string   "rfid_tag",       limit: 29,  null: false
    t.float    "weight",         limit: 24,  null: false
    t.boolean  "fragile",        limit: 1,   null: false
    t.boolean  "flammable",      limit: 1,   null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "goods", ["order_id"], name: "order_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "sender_id",         limit: 4,   null: false
    t.integer  "receiver_id",       limit: 4,   null: false
    t.string   "receiver_type",     limit: 255, null: false
    t.integer  "departure_id",      limit: 4,   null: false
    t.string   "departure_type",    limit: 255, null: false
    t.integer  "destination_id",    limit: 4,   null: false
    t.string   "destination_type",  limit: 255, null: false
    t.datetime "receive_time"
    t.integer  "staff_id",          limit: 4,   null: false
    t.boolean  "pay_from_receiver", limit: 1,   null: false
    t.datetime "pay_time"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "orders", ["sender_id"], name: "sender_id", using: :btree
  add_index "orders", ["staff_id"], name: "staff_id", using: :btree

  create_table "permission_staff_ships", id: false, force: :cascade do |t|
    t.integer "permission_id", limit: 4, null: false
    t.integer "staff_id",      limit: 4, null: false
  end

  add_index "permission_staff_ships", ["staff_id"], name: "staff_id", using: :btree

  create_table "permissions", force: :cascade do |t|
    t.string "name", limit: 40, null: false
  end

  add_index "permissions", ["name"], name: "index_permissions_on_name", unique: true, using: :btree

  create_table "public_receivers", force: :cascade do |t|
    t.string "name",  limit: 40,  null: false
    t.string "email", limit: 255, null: false
    t.string "phone", limit: 17,  null: false
  end

  create_table "regions", force: :cascade do |t|
    t.string  "name",     limit: 255, null: false
    t.integer "store_id", limit: 4,   null: false
  end

  add_index "regions", ["name"], name: "index_regions_on_name", unique: true, using: :btree

  create_table "registered_users", force: :cascade do |t|
    t.string   "username",   limit: 20,  null: false
    t.string   "password",   limit: 32,  null: false
    t.boolean  "is_freeze",  limit: 1,   null: false
    t.string   "name",       limit: 40,  null: false
    t.string   "email",      limit: 255, null: false
    t.string   "phone",      limit: 17,  null: false
    t.string   "type",       limit: 40,  null: false
    t.integer  "car_id",     limit: 4
    t.boolean  "driver",     limit: 1
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "registered_users", ["car_id"], name: "car_id", using: :btree
  add_index "registered_users", ["username"], name: "index_registered_users_on_username", unique: true, using: :btree

  create_table "shops", force: :cascade do |t|
    t.string  "address",   limit: 255, null: false
    t.integer "region_id", limit: 4,   null: false
  end

  add_index "shops", ["address"], name: "index_shops_on_address", unique: true, using: :btree

  create_table "specify_address_user_ships", id: false, force: :cascade do |t|
    t.integer "specify_address_id", limit: 4,   null: false
    t.integer "user_id",            limit: 4,   null: false
    t.string  "user_type",          limit: 255, null: false
  end

  create_table "specify_addresses", force: :cascade do |t|
    t.string  "address",   limit: 255, null: false
    t.integer "region_id", limit: 4,   null: false
  end

  add_index "specify_addresses", ["address", "region_id"], name: "index_specify_addresses_on_address_and_region_id", unique: true, using: :btree

  create_table "stores", force: :cascade do |t|
    t.string  "address", limit: 255, null: false
    t.integer "size",    limit: 4,   null: false
  end

  add_index "stores", ["address"], name: "index_stores_on_address", unique: true, using: :btree

  add_foreign_key "check_logs", "check_actions", name: "check_logs_ibfk_1"
  add_foreign_key "check_logs", "goods", name: "check_logs_ibfk_2"
  add_foreign_key "check_logs", "registered_users", column: "staff_id", name: "check_logs_ibfk_3"
  add_foreign_key "conveyor_control_logs", "conveyors", name: "conveyor_control_logs_ibfk_1"
  add_foreign_key "conveyor_control_logs", "registered_users", column: "staff_id", name: "conveyor_control_logs_ibfk_2"
  add_foreign_key "conveyors", "stores", name: "conveyors_ibfk_1"
  add_foreign_key "goods", "orders", name: "goods_ibfk_1"
  add_foreign_key "orders", "registered_users", column: "sender_id", name: "orders_ibfk_1"
  add_foreign_key "orders", "registered_users", column: "staff_id", name: "orders_ibfk_2"
  add_foreign_key "permission_staff_ships", "permissions", name: "permission_staff_ships_ibfk_1"
  add_foreign_key "permission_staff_ships", "registered_users", column: "staff_id", name: "permission_staff_ships_ibfk_2"
  add_foreign_key "registered_users", "cars", name: "registered_users_ibfk_1"
  add_foreign_key "specify_address_user_ships", "specify_addresses", name: "specify_address_user_ships_ibfk_1"
end
