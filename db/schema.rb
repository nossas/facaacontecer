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

ActiveRecord::Schema.define(:version => 20130104225519) do

  create_table "orders", :id => false, :force => true do |t|
    t.string   "token"
    t.string   "transaction_id"
    t.string   "address_one"
    t.string   "address_two"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "status"
    t.string   "number"
    t.string   "uuid"
    t.string   "phone"
    t.string   "name"
    t.date     "expiration"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "project_id"
    t.decimal  "value"
    t.string   "email"
    t.string   "cpf"
    t.string   "address_neighbourhood"
    t.integer  "address_number"
    t.date     "birthday"
  end

  add_index "orders", ["email"], :name => "index_orders_on_email"
  add_index "orders", ["project_id"], :name => "index_orders_on_project_id"

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.decimal  "goal"
    t.datetime "expiration_date"
    t.string   "image"
    t.string   "video"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
