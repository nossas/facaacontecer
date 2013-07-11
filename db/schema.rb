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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130711145156) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "invites", :force => true do |t|
    t.string   "code"
    t.integer  "user_id"
    t.integer  "parent_user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "invites", ["code", "user_id"], :name => "index_invites_on_code_and_user_id", :unique => true
  add_index "invites", ["user_id", "parent_user_id"], :name => "index_invites_on_user_id_and_parent_user_id"

  create_table "orders", :force => true do |t|
    t.integer  "user_id",                     :null => false
    t.integer  "project_id",                  :null => false
    t.decimal  "value",      :default => 0.0
    t.string   "token"
    t.string   "status"
    t.string   "uuid"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "orders", ["project_id"], :name => "index_orders_on_project_id"
  add_index "orders", ["token"], :name => "index_orders_on_token", :unique => true
  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"
  add_index "orders", ["uuid"], :name => "index_orders_on_uuid"

  create_table "payment_instructions", :force => true do |t|
    t.string   "code"
    t.integer  "subscription_id"
    t.string   "status"
    t.datetime "expires_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.datetime "paid_at"
    t.string   "url"
    t.string   "sequence"
  end

  add_index "payment_instructions", ["subscription_id"], :name => "index_payment_instructions_on_subscription_id"

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.date     "expiration_date"
    t.decimal  "goal"
    t.string   "image"
    t.string   "video"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "days"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "project_id",                               :null => false
    t.decimal  "value",          :default => 0.0
    t.string   "status"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "code"
    t.integer  "subscriber_id"
    t.boolean  "anonymous"
    t.boolean  "gift"
    t.string   "payment_option", :default => "creditcard", :null => false
  end

  add_index "subscriptions", ["code"], :name => "index_subscriptions_on_code"
  add_index "subscriptions", ["project_id"], :name => "index_subscriptions_on_project_id"
  add_index "subscriptions", ["subscriber_id"], :name => "index_subscriptions_on_subscriber_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "cpf"
    t.date     "birthday"
    t.string   "address_street"
    t.string   "address_extra"
    t.string   "address_number"
    t.string   "address_district"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zipcode"
    t.string   "phone"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"

end
