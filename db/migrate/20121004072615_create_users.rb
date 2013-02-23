class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, unique: true
      t.string :cpf
      t.date   :birthday
      t.string :address_street
      t.string :address_extra
      t.string :address_number
      t.string :address_district
      t.string :city
      t.string :state
      t.string :country
      t.string :zipcode
      t.string :phone
 
      
      t.timestamps
    end
    add_index :users, :email
  end
end
