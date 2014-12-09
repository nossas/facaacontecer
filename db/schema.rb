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

ActiveRecord::Schema.define(version: 20141209133128) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "invites", force: true do |t|
    t.string   "code"
    t.integer  "user_id"
    t.integer  "parent_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], :name => "fk__invites_user_id", :order => {"user_id" => :asc}
    t.index ["code", "user_id"], :name => "index_invites_on_code_and_user_id", :unique => true, :order => {"code" => :asc, "user_id" => :asc}
    t.index ["user_id", "parent_user_id"], :name => "index_invites_on_user_id_and_parent_user_id", :order => {"user_id" => :asc, "parent_user_id" => :asc}
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "project_id",                              null: false
    t.decimal  "value",            default: 0.0
    t.string   "state",            default: "processing"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
    t.integer  "user_id"
    t.boolean  "anonymous"
    t.boolean  "gift"
    t.string   "payment_option",   default: "",           null: false
    t.string   "plan",             default: "0",          null: false
    t.string   "bank"
    t.datetime "state_updated_at"
    t.integer  "organization_id"
    t.index ["code"], :name => "index_subscriptions_on_code", :unique => true, :order => {"code" => :asc}
    t.index ["project_id"], :name => "index_subscriptions_on_project_id", :order => {"project_id" => :asc}
    t.index ["user_id"], :name => "index_subscriptions_on_user_id", :order => {"user_id" => :asc}
  end

  create_table "invoices", force: true do |t|
    t.integer  "uid",                null: false
    t.integer  "subscription_id",    null: false
    t.decimal  "value",              null: false
    t.integer  "occurrence",         null: false
    t.string   "status",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "created_on_moip_at"
    t.index ["subscription_id"], :name => "fk__invoices_subscription_id", :order => {"subscription_id" => :asc}
    t.index ["uid"], :name => "index_invoices_on_uid", :unique => true, :order => {"uid" => :asc}
    t.foreign_key ["subscription_id"], "subscriptions", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_invoices_subscription_id"
  end

  create_table "organizations", force: true do |t|
    t.string "name"
    t.string "mailchimp_list_id"
  end

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
    t.string   "token"
    t.index ["subscription_id"], :name => "fk__payments_subscription_id", :order => {"subscription_id" => :asc}
    t.index ["subscription_id"], :name => "index_payments_on_subscription_id", :order => {"subscription_id" => :asc}
    t.foreign_key ["subscription_id"], "subscriptions", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_payments_subscription_id"
  end

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

  create_view "successful_transactions", " SELECT p.id,\n    psub.user_id,\n    'payments'::text AS relname\n   FROM (payments p\n     JOIN subscriptions psub ON ((psub.id = p.subscription_id)))\n  WHERE (((p.state)::text = 'finished'::text) OR ((p.state)::text = 'authorized'::text))\nUNION ALL\n SELECT i.id,\n    isub.user_id,\n    'invoices'::text AS relname\n   FROM (invoices i\n     JOIN subscriptions isub ON ((isub.id = i.subscription_id)))\n  WHERE ((i.status)::text = 'finished'::text)", :force => true
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
    t.string   "postal_code"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token"
  end

end
