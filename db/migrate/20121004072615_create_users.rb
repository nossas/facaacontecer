class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, unique: true
      t.string :cpf
      t.date   :birthday
      t.string :address_street
      t.string :address_street_extra
      t.string :address_street_number
      t.string :address_neighbourhood
      t.string :address_city
      t.string :address_state
      t.string :address_country
      t.string :address_cep
      t.string :address_phone
 
      
      t.timestamps
    end
    add_index :users, :email
  end
end
