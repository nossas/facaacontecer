class DropTableUsers < ActiveRecord::Migration
  def up
    drop_table :users
  end

  def down
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
      t.string   "image"
    end
  end
end
