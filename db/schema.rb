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

  create_table "cars", force: true do |t|
    t.integer "driver_id"
    t.integer "partner_id"
    t.string  "vehicle_registration_mark", limit: 8, null: false
  end

  add_index "cars", ["driver_id"], name: "driver_id", using: :btree
  add_index "cars", ["partner_id"], name: "partner_id", using: :btree
  add_index "cars", ["vehicle_registration_mark"], name: "index_cars_on_vehicle_registration_mark", unique: true, using: :btree

  create_table "check_actions", force: true do |t|
    t.string "name", null: false
  end

  add_index "check_actions", ["name"], name: "index_check_actions_on_name", unique: true, using: :btree

  create_table "check_logs", id: false, force: true do |t|
    t.datetime "time",            null: false
    t.integer  "good_id",         null: false
    t.integer  "location_id",     null: false
    t.string   "location_type",   null: false
    t.integer  "check_action_id", null: false
    t.integer  "staff_id",        null: false
  end

  add_index "check_logs", ["check_action_id"], name: "check_action_id", using: :btree
  add_index "check_logs", ["good_id"], name: "good_id", using: :btree
  add_index "check_logs", ["staff_id"], name: "staff_id", using: :btree

  create_table "conveyor_control_actions", force: true do |t|
    t.string "name", null: false
  end

  add_index "conveyor_control_actions", ["name"], name: "index_conveyor_control_actions_on_name", unique: true, using: :btree

  create_table "conveyor_control_logs", id: false, force: true do |t|
    t.datetime "time",                       null: false
    t.integer  "conveyor_id",                null: false
    t.integer  "conveyor_control_action_id", null: false
    t.integer  "string_id",                  null: false
    t.integer  "staff_id",                   null: false
  end

  add_index "conveyor_control_logs", ["conveyor_control_action_id"], name: "conveyor_control_action_id", using: :btree
  add_index "conveyor_control_logs", ["conveyor_id"], name: "conveyor_id", using: :btree
  add_index "conveyor_control_logs", ["staff_id"], name: "staff_id", using: :btree

  create_table "conveyors", force: true do |t|
    t.string  "name",             limit: 40, null: false
    t.integer "store_address_id",            null: false
    t.string  "server_ip",                   null: false
    t.integer "server_port",      limit: 8,  null: false
    t.boolean "passive",                     null: false
  end

  add_index "conveyors", ["name"], name: "index_conveyors_on_name", unique: true, using: :btree
  add_index "conveyors", ["store_address_id"], name: "store_address_id", using: :btree

  create_table "goods", force: true do |t|
    t.integer  "order_id",                 null: false
    t.integer  "location_id",              null: false
    t.string   "location_type",            null: false
    t.string   "rfid_tag",      limit: 40, null: false
    t.float    "weight",        limit: 24, null: false
    t.boolean  "fragile",                  null: false
    t.boolean  "flammable",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "goods", ["order_id"], name: "order_id", using: :btree

  create_table "orders", force: true do |t|
    t.integer  "sender_id",         null: false
    t.integer  "receiver_id",       null: false
    t.string   "receiver_type",     null: false
    t.datetime "receive_time"
    t.integer  "staff_id",          null: false
    t.boolean  "pay_from_receiver", null: false
    t.datetime "pay_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["sender_id"], name: "sender_id", using: :btree
  add_index "orders", ["staff_id"], name: "staff_id", using: :btree

  create_table "permission_staff_ships", id: false, force: true do |t|
    t.integer "permission_id", null: false
    t.integer "staff_id",      null: false
  end

  add_index "permission_staff_ships", ["staff_id"], name: "staff_id", using: :btree

  create_table "permissions", force: true do |t|
    t.string "name", limit: 40, null: false
  end

  add_index "permissions", ["name"], name: "index_permissions_on_name", unique: true, using: :btree

  create_table "public_receivers", force: true do |t|
    t.string "name",  limit: 40
    t.string "email"
    t.string "phone", limit: 17
  end

  create_table "registered_users", force: true do |t|
    t.string   "username",   limit: 20
    t.string   "password",   limit: 32
    t.boolean  "is_freeze"
    t.string   "name",       limit: 40, null: false
    t.string   "email",                 null: false
    t.string   "phone",      limit: 17, null: false
    t.string   "type",       limit: 40, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "registered_users", ["username"], name: "index_registered_users_on_username", unique: true, using: :btree

  create_table "shop_addresses", force: true do |t|
    t.string "address", null: false
  end

  add_index "shop_addresses", ["address"], name: "index_shop_addresses_on_address", unique: true, using: :btree

  create_table "specify_addresses", force: true do |t|
    t.string "address", null: false
  end

  add_index "specify_addresses", ["address"], name: "index_specify_addresses_on_address", unique: true, using: :btree

  create_table "specify_addresses_user_ships", id: false, force: true do |t|
    t.integer "specify_address_id", null: false
    t.integer "user_id",            null: false
    t.string  "user_type",          null: false
  end

  create_table "store_addresses", force: true do |t|
    t.string  "address", null: false
    t.integer "size"
  end

  add_index "store_addresses", ["address"], name: "index_store_addresses_on_address", unique: true, using: :btree

end
