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

  create_table "address_types", force: true do |t|
    t.string  "name",                      null: false
    t.boolean "has_size",                  null: false
    t.boolean "is_unique", default: false, null: false
  end

  add_index "address_types", ["name"], name: "index_address_types_on_name", unique: true, using: :btree

  create_table "address_user_ships", id: false, force: true do |t|
    t.integer "address_id", null: false
    t.integer "user_id",    null: false
  end

  add_index "address_user_ships", ["user_id"], name: "user_id", using: :btree

  create_table "addresses", force: true do |t|
    t.string   "address",         null: false
    t.integer  "size"
    t.integer  "address_type_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["address"], name: "index_addresses_on_address", unique: true, using: :btree
  add_index "addresses", ["address_type_id"], name: "address_type_id", using: :btree

  create_table "check_actions", force: true do |t|
    t.string "name", null: false
  end

  add_index "check_actions", ["name"], name: "index_check_actions_on_name", unique: true, using: :btree

  create_table "check_logs", id: false, force: true do |t|
    t.datetime "time",            null: false
    t.integer  "good_id",         null: false
    t.integer  "location_id",     null: false
    t.integer  "check_action_id", null: false
    t.integer  "staff_id",        null: false
  end

  add_index "check_logs", ["check_action_id"], name: "check_action_id", using: :btree
  add_index "check_logs", ["good_id"], name: "good_id", using: :btree
  add_index "check_logs", ["location_id"], name: "location_id", using: :btree
  add_index "check_logs", ["staff_id"], name: "staff_id", using: :btree

  create_table "conveyors", force: true do |t|
    t.string  "name",        limit: 40, null: false
    t.integer "location_id",            null: false
    t.string  "server_ip",              null: false
    t.integer "server_port", limit: 8,  null: false
    t.boolean "passive",                null: false
  end

  add_index "conveyors", ["location_id"], name: "location_id", using: :btree
  add_index "conveyors", ["name"], name: "index_conveyors_on_name", unique: true, using: :btree

  create_table "goods", force: true do |t|
    t.integer  "order_id",               null: false
    t.integer  "location_id",            null: false
    t.string   "rfid_tag",    limit: 40, null: false
    t.float    "weight",      limit: 24, null: false
    t.boolean  "fragile",                null: false
    t.boolean  "flammable",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "goods", ["location_id"], name: "location_id", using: :btree
  add_index "goods", ["order_id"], name: "order_id", using: :btree

  create_table "orders", force: true do |t|
    t.integer  "sender_id",    null: false
    t.integer  "receiver_id",  null: false
    t.datetime "receive_time"
    t.integer  "staff_id",     null: false
    t.integer  "payer_id",     null: false
    t.datetime "pay_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["payer_id"], name: "payer_id", using: :btree
  add_index "orders", ["receiver_id"], name: "receiver_id", using: :btree
  add_index "orders", ["sender_id"], name: "sender_id", using: :btree
  add_index "orders", ["staff_id"], name: "staff_id", using: :btree

  create_table "permission_user_ships", id: false, force: true do |t|
    t.integer "permission_id", null: false
    t.integer "user_id",       null: false
  end

  add_index "permission_user_ships", ["user_id"], name: "user_id", using: :btree

  create_table "permissions", force: true do |t|
    t.string "name", limit: 40, null: false
  end

  add_index "permissions", ["name"], name: "index_permissions_on_name", unique: true, using: :btree

  create_table "user_types", force: true do |t|
    t.string  "name",                      null: false
    t.boolean "is_unique", default: false, null: false
    t.boolean "can_login", default: true,  null: false
  end

  add_index "user_types", ["name"], name: "index_user_types_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "username",     limit: 20
    t.string   "password",     limit: 32
    t.boolean  "is_freeze"
    t.string   "name",         limit: 40, null: false
    t.string   "email",                   null: false
    t.string   "phone",        limit: 17, null: false
    t.integer  "user_type_id",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["user_type_id"], name: "user_type_id", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
