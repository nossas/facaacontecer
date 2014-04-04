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

ActiveRecord::Schema.define(version: 20140404021032) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "invites", force: true do |t|
    t.string   "code"
    t.integer  "user_id"
    t.integer  "parent_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invites", ["code", "user_id"], name: "index_invites_on_code_and_user_id", unique: true, using: :btree
  add_index "invites", ["user_id", "parent_user_id"], name: "index_invites_on_user_id_and_parent_user_id", using: :btree

  create_table "payments", force: true do |t|
    t.string   "code"
    t.integer  "subscription_id"
    t.string   "state"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "paid_at"
    t.string   "url"
    t.string   "sequence"
  end

  add_index "payments", ["subscription_id"], name: "index_payments_on_subscription_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.date     "expiration_date"
    t.decimal  "goal"
    t.string   "image"
    t.string   "video"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "days"
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "project_id",                   null: false
    t.decimal  "value",          default: 0.0
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
    t.integer  "user_id"
    t.boolean  "anonymous"
    t.boolean  "gift"
    t.string   "payment_option", default: "",  null: false
    t.string   "plan",                         null: false
    t.string   "bank"
  end

  add_index "subscriptions", ["code"], name: "index_subscriptions_on_code", using: :btree
  add_index "subscriptions", ["project_id"], name: "index_subscriptions_on_project_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name",       null: false
    t.string   "last_name",        null: false
    t.string   "email",            null: false
    t.string   "cpf"
    t.date     "birthday",         null: false
    t.string   "address_street"
    t.string   "address_extra"
    t.string   "address_number"
    t.string   "address_district"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zipcode"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
