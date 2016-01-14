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

ActiveRecord::Schema.define(version: 20160114124317) do

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "name",                   limit: 255, default: "", null: false
    t.string   "phone",                  limit: 255, default: "", null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["phone"], name: "index_admins_on_phone", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "alarm_histories", force: :cascade do |t|
    t.integer  "point_id",     limit: 4
    t.datetime "checked_time"
    t.integer  "check_state",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "alarm_histories", ["point_id"], name: "index_alarm_histories_on_point_id", using: :btree

  create_table "alarms", force: :cascade do |t|
    t.string   "voltage",      limit: 255
    t.string   "current",      limit: 255
    t.boolean  "volt_warning"
    t.boolean  "cur_warning"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "analog_alarms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "analog_points", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devices", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "pattern_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "room_id",    limit: 4
  end

  add_index "devices", ["pattern_id"], name: "index_devices_on_pattern_id", using: :btree
  add_index "devices", ["room_id"], name: "index_devices_on_room_id", using: :btree

  create_table "digital_alarms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "digital_points", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menus", force: :cascade do |t|
    t.integer  "room_id",       limit: 4
    t.integer  "menuable_id",   limit: 4
    t.string   "menuable_type", limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "menus", ["menuable_id", "menuable_type"], name: "index_menus_on_menuable_id_and_menuable_type", using: :btree
  add_index "menus", ["room_id"], name: "index_menus_on_room_id", using: :btree

  create_table "patterns", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "partial_path",  limit: 255
    t.integer  "sub_system_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "patterns", ["sub_system_id"], name: "index_patterns_on_sub_system_id", using: :btree

  create_table "point_alarms", force: :cascade do |t|
    t.integer  "pid",        limit: 4
    t.integer  "state",      limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "point_id",   limit: 4
    t.boolean  "is_checked",           default: false
  end

  add_index "point_alarms", ["point_id"], name: "index_point_alarms_on_point_id", using: :btree

  create_table "point_histories", force: :cascade do |t|
    t.string   "point_name",  limit: 255
    t.float    "point_value", limit: 24
    t.integer  "point_id",    limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "point_histories", ["point_id"], name: "index_point_histories_on_point_id", using: :btree

  create_table "point_states", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "points", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "point_index", limit: 255
    t.integer  "device_id",   limit: 4
  end

  add_index "points", ["device_id"], name: "index_points_on_device_id", using: :btree

  create_table "rooms", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "link",         limit: 255
    t.string   "monitor_link", limit: 255
  end

  create_table "sub_systems", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "system_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "sub_systems", ["system_id"], name: "index_sub_systems_on_system_id", using: :btree

  create_table "systems", force: :cascade do |t|
    t.string   "sys_name",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "user_rooms", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "room_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "user_rooms", ["room_id"], name: "index_user_rooms_on_room_id", using: :btree
  add_index "user_rooms", ["user_id"], name: "index_user_rooms_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "name",                   limit: 255, default: "", null: false
    t.string   "phone",                  limit: 255, default: "", null: false
    t.string   "authentication_token",   limit: 255
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["phone"], name: "index_users_on_phone", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "alarm_histories", "points"
  add_foreign_key "devices", "patterns"
  add_foreign_key "devices", "rooms"
  add_foreign_key "menus", "rooms"
  add_foreign_key "point_alarms", "points"
  add_foreign_key "point_histories", "points"
  add_foreign_key "points", "devices"
  add_foreign_key "sub_systems", "systems"
  add_foreign_key "user_rooms", "rooms"
  add_foreign_key "user_rooms", "users"
end
