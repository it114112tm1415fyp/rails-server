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
    t.string  "vehicle_registration_mark", limit: 8,                null: false
    t.boolean "enable",                    limit: 1, default: true, null: false
  end

  add_index "cars", ["vehicle_registration_mark"], name: "index_cars_on_vehicle_registration_mark", unique: true, using: :btree

  create_table "check_actions", force: :cascade do |t|
    t.string "name", limit: 40, null: false
  end

  add_index "check_actions", ["name"], name: "index_check_actions_on_name", unique: true, using: :btree

  create_table "check_logs", force: :cascade do |t|
    t.datetime "time",                        null: false
    t.integer  "task_worker_id",  limit: 4,   null: false
    t.integer  "task_goods_id",   limit: 4,   null: false
    t.string   "task_goods_type", limit: 255, null: false
  end

  create_table "constants", force: :cascade do |t|
    t.string "key",   limit: 255, null: false
    t.string "value", limit: 255, null: false
  end

  add_index "constants", ["key"], name: "index_constants_on_key", unique: true, using: :btree

  create_table "conveyors", force: :cascade do |t|
    t.string  "name",        limit: 40,  null: false
    t.integer "store_id",    limit: 4,   null: false
    t.string  "server_ip",   limit: 255, null: false
    t.integer "server_port", limit: 8,   null: false
    t.boolean "passive",     limit: 1,   null: false
  end

  add_index "conveyors", ["name"], name: "index_conveyors_on_name", unique: true, using: :btree

  create_table "free_times", force: :cascade do |t|
    t.integer "order_id",                limit: 4, null: false
    t.integer "receive_time_segment_id", limit: 4, null: false
    t.date    "date",                              null: false
    t.boolean "free",                    limit: 1, null: false
  end

  create_table "goods", force: :cascade do |t|
    t.integer  "order_id",       limit: 4,     null: false
    t.integer  "location_id",    limit: 4,     null: false
    t.string   "location_type",  limit: 255,   null: false
    t.integer  "next_stop_id",   limit: 4,     null: false
    t.string   "next_stop_type", limit: 255,   null: false
    t.integer  "shelf_id",       limit: 4
    t.integer  "staff_id",       limit: 4,     null: false
    t.integer  "last_action_id", limit: 4,     null: false
    t.string   "string_id",      limit: 6,     null: false
    t.string   "rfid_tag",       limit: 29
    t.float    "weight",         limit: 24,    null: false
    t.boolean  "fragile",        limit: 1,     null: false
    t.boolean  "flammable",      limit: 1,     null: false
    t.binary   "goods_photo",    limit: 65535, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "goods", ["rfid_tag"], name: "index_goods_on_rfid_tag", unique: true, using: :btree
  add_index "goods", ["string_id"], name: "index_goods_on_string_id", unique: true, using: :btree

  create_table "goods_inspect_task_ships", force: :cascade do |t|
    t.integer "goods_id",        limit: 4, null: false
    t.integer "inspect_task_id", limit: 4, null: false
  end

  add_index "goods_inspect_task_ships", ["goods_id", "inspect_task_id"], name: "goods_inspect_task_ships_unique", unique: true, using: :btree

  create_table "goods_serve_task_ships", force: :cascade do |t|
    t.integer "goods_id",      limit: 4, null: false
    t.integer "serve_task_id", limit: 4, null: false
  end

  add_index "goods_serve_task_ships", ["goods_id", "serve_task_id"], name: "goods_serve_task_ships_unique", unique: true, using: :btree

  create_table "goods_transfer_task_ships", force: :cascade do |t|
    t.integer "goods_id",         limit: 4, null: false
    t.integer "transfer_task_id", limit: 4, null: false
  end

  add_index "goods_transfer_task_ships", ["goods_id", "transfer_task_id"], name: "goods_transfer_task_ships_unique", unique: true, using: :btree

  create_table "goods_visit_task_order_ships", force: :cascade do |t|
    t.integer "goods_id",            limit: 4, null: false
    t.integer "visit_task_order_id", limit: 4, null: false
  end

  add_index "goods_visit_task_order_ships", ["goods_id", "visit_task_order_id"], name: "goods_visit_task_order_ships_unique", unique: true, using: :btree

  create_table "inspect_task_plans", force: :cascade do |t|
    t.integer "day",      limit: 4, null: false
    t.time    "time",               null: false
    t.integer "store_id", limit: 4, null: false
  end

  create_table "inspect_tasks", force: :cascade do |t|
    t.datetime "datetime",                            null: false
    t.integer  "store_id",  limit: 4,                 null: false
    t.boolean  "generated", limit: 1, default: false, null: false
    t.boolean  "completed", limit: 1, default: false, null: false
  end

  create_table "metal_gateways", force: :cascade do |t|
    t.string  "name",      limit: 40,  null: false
    t.integer "store_id",  limit: 4,   null: false
    t.string  "server_ip", limit: 255, null: false
  end

  add_index "metal_gateways", ["name"], name: "index_metal_gateways_on_name", unique: true, using: :btree

  create_table "order_queues", force: :cascade do |t|
    t.integer "order_id",      limit: 4, null: false
    t.integer "queue_times",   limit: 4, null: false
    t.boolean "receive",       limit: 1, null: false
    t.integer "visit_task_id", limit: 4
  end

  add_index "order_queues", ["order_id"], name: "index_order_queues_on_order_id", unique: true, using: :btree

  create_table "order_status", force: :cascade do |t|
    t.string "name", limit: 40, null: false
  end

  add_index "order_status", ["name"], name: "index_order_status_on_name", unique: true, using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "sender_id",            limit: 4,     null: false
    t.binary   "sender_sign",          limit: 65535
    t.integer  "receiver_id",          limit: 4,     null: false
    t.string   "receiver_type",        limit: 255,   null: false
    t.binary   "receiver_sign",        limit: 65535
    t.integer  "departure_id",         limit: 4,     null: false
    t.string   "departure_type",       limit: 255,   null: false
    t.integer  "destination_id",       limit: 4,     null: false
    t.string   "destination_type",     limit: 255,   null: false
    t.integer  "goods_number",         limit: 4,     null: false
    t.integer  "staff_id",             limit: 4
    t.integer  "order_state_id",       limit: 4,     null: false
    t.datetime "receive_time_version",               null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "public_receivers", force: :cascade do |t|
    t.string "name",  limit: 40,  null: false
    t.string "email", limit: 255, null: false
    t.string "phone", limit: 17,  null: false
  end

  create_table "receive_time_segments", force: :cascade do |t|
    t.time    "start_time",                          null: false
    t.time    "end_time",                            null: false
    t.boolean "enable",     limit: 1, default: true, null: false
  end

  add_index "receive_time_segments", ["start_time", "end_time"], name: "index_receive_time_segments_on_start_time_and_end_time", unique: true, using: :btree

  create_table "regions", force: :cascade do |t|
    t.string  "name",     limit: 40,                null: false
    t.integer "store_id", limit: 4,                 null: false
    t.boolean "enable",   limit: 1,  default: true, null: false
  end

  add_index "regions", ["name"], name: "index_regions_on_name", unique: true, using: :btree

  create_table "registered_users", force: :cascade do |t|
    t.string   "type",           limit: 40,                 null: false
    t.string   "username",       limit: 20,                 null: false
    t.string   "password",       limit: 32,                 null: false
    t.string   "name",           limit: 40,                 null: false
    t.string   "email",          limit: 255,                null: false
    t.string   "phone",          limit: 17,                 null: false
    t.integer  "workplace_id",   limit: 4
    t.string   "workplace_type", limit: 255
    t.boolean  "enable",         limit: 1,   default: true, null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "registered_users", ["username"], name: "index_registered_users_on_username", unique: true, using: :btree

  create_table "scheme_versions", force: :cascade do |t|
    t.string   "scheme_name",        limit: 255, null: false
    t.datetime "scheme_update_time",             null: false
  end

  create_table "serve_tasks", force: :cascade do |t|
    t.datetime "datetime",           null: false
    t.integer  "shop_id",  limit: 4, null: false
  end

  create_table "shops", force: :cascade do |t|
    t.string  "name",      limit: 40,                 null: false
    t.string  "address",   limit: 255,                null: false
    t.integer "region_id", limit: 4,                  null: false
    t.boolean "enable",    limit: 1,   default: true, null: false
  end

  add_index "shops", ["address"], name: "index_shops_on_address", unique: true, using: :btree

  create_table "specify_address_user_ships", force: :cascade do |t|
    t.integer "specify_address_id", limit: 4,   null: false
    t.integer "user_id",            limit: 4,   null: false
    t.string  "user_type",          limit: 255, null: false
  end

  add_index "specify_address_user_ships", ["specify_address_id", "user_id", "user_type"], name: "specify_address_user_ships_unique", unique: true, using: :btree

  create_table "specify_addresses", force: :cascade do |t|
    t.string  "address",   limit: 255, null: false
    t.integer "region_id", limit: 4,   null: false
  end

  add_index "specify_addresses", ["address", "region_id"], name: "index_specify_addresses_on_address_and_region_id", unique: true, using: :btree

  create_table "stores", force: :cascade do |t|
    t.string  "name",         limit: 40,                 null: false
    t.string  "address",      limit: 255,                null: false
    t.integer "shelf_number", limit: 4,                  null: false
    t.boolean "enable",       limit: 1,   default: true, null: false
  end

  add_index "stores", ["address"], name: "index_stores_on_address", unique: true, using: :btree

  create_table "task_workers", force: :cascade do |t|
    t.integer "staff_id",        limit: 4,   null: false
    t.integer "task_id",         limit: 4,   null: false
    t.string  "task_type",       limit: 255, null: false
    t.integer "check_action_id", limit: 4,   null: false
  end

  create_table "transfer_task_plans", force: :cascade do |t|
    t.integer "day",       limit: 4,   null: false
    t.time    "time",                  null: false
    t.integer "car_id",    limit: 4,   null: false
    t.integer "from_id",   limit: 4,   null: false
    t.string  "from_type", limit: 255, null: false
    t.integer "to_id",     limit: 4,   null: false
    t.string  "to_type",   limit: 255, null: false
    t.integer "number",    limit: 4,   null: false
  end

  create_table "transfer_tasks", force: :cascade do |t|
    t.datetime "datetime",                              null: false
    t.integer  "car_id",    limit: 4,                   null: false
    t.integer  "from_id",   limit: 4,                   null: false
    t.string   "from_type", limit: 255,                 null: false
    t.integer  "to_id",     limit: 4,                   null: false
    t.string   "to_type",   limit: 255,                 null: false
    t.integer  "number",    limit: 4,                   null: false
    t.boolean  "generated", limit: 1,   default: false, null: false
    t.boolean  "completed", limit: 1,   default: false, null: false
  end

  create_table "visit_task_orders", force: :cascade do |t|
    t.integer "order_id",      limit: 4,                 null: false
    t.integer "visit_task_id", limit: 4,                 null: false
    t.boolean "completed",     limit: 1, default: false, null: false
  end

  add_index "visit_task_orders", ["order_id", "visit_task_id"], name: "order_visit_task_ships_unique", unique: true, using: :btree

  create_table "visit_task_plans", force: :cascade do |t|
    t.string  "type",      limit: 40, null: false
    t.integer "day",       limit: 4,  null: false
    t.time    "time",                 null: false
    t.integer "car_id",    limit: 4,  null: false
    t.integer "region_id", limit: 4,  null: false
    t.integer "number",    limit: 4,  null: false
  end

  create_table "visit_tasks", force: :cascade do |t|
    t.string   "type",      limit: 40,                 null: false
    t.datetime "datetime",                             null: false
    t.integer  "car_id",    limit: 4,                  null: false
    t.integer  "region_id", limit: 4,                  null: false
    t.integer  "number",    limit: 4,                  null: false
    t.boolean  "generated", limit: 1,  default: false, null: false
    t.boolean  "contacted", limit: 1,  default: false, null: false
    t.boolean  "received",  limit: 1,  default: false, null: false
    t.boolean  "completed", limit: 1,  default: false, null: false
  end

end
