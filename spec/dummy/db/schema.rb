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

ActiveRecord::Schema.define(version: 20140304101015) do

  create_table "admin_users", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gossiper_notifications", force: true do |t|
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "kind"
    t.string   "status"
    t.datetime "delivered_at"
    t.boolean  "read"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "data"
    t.string   "type"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
