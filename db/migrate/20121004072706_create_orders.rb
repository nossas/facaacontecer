class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id,     null: false
      t.integer :project_id,  null: false
      t.decimal :value,   default: 0.0
      t.string  :token,   default: nil
      t.string  :status,  default: nil
      t.string  :uuid,    default: nil

      t.timestamps
    end


    add_index :orders, :token, unique: true
    add_index :orders, :uuid
    add_index :orders, :user_id
    add_index :orders, :project_id
  end
end
