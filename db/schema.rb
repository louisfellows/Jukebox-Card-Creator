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

ActiveRecord::Schema.define(version: 20160823112032) do

  create_table "album_listings", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "album_id",   null: false
    t.integer  "number",     null: false
    t.datetime "created_at", null: false
  end

  create_table "albums", force: :cascade do |t|
    t.integer  "user_id",                                          null: false
    t.string   "title",       limit: 100,                          null: false
    t.string   "image",       limit: 1024
    t.datetime "created_at",                                       null: false
    t.string   "artist",      limit: 100,  default: "Terrorbeard", null: false
    t.string   "small_image", limit: 1024
  end

  create_table "cards", force: :cascade do |t|
    t.integer  "user_id",                   null: false
    t.integer  "style",      default: 1,    null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "font",       default: 1,    null: false
    t.boolean  "numbers",    default: true, null: false
    t.decimal  "height",     default: 12.0, null: false
    t.decimal  "width",      default: 18.0, null: false
  end

  create_table "tracks", force: :cascade do |t|
    t.integer  "album_id",                 null: false
    t.string   "track_name",   limit: 100, null: false
    t.integer  "track_number",             null: false
    t.datetime "created_at",               null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider",                                  null: false
    t.string   "uid",                                       null: false
    t.string   "name"
    t.string   "location"
    t.string   "image_url"
    t.string   "url"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "role",       limit: 10, default: "default", null: false
  end

  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  add_index "users", ["provider"], name: "index_users_on_provider"
  add_index "users", ["uid"], name: "index_users_on_uid"

end
