class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id,     null: false
      t.integer :project_id,  null: false, foreign_key: false
      t.decimal :value,   default: 0.0
      t.string  :token,   default: nil
      t.string  :status,  default: nil
      t.string  :uuid,    default: nil

      t.timestamps
    end


    add_index :subscriptions, :token, unique: true
    add_index :subscriptions, :uuid
    add_index :subscriptions, :user_id
    add_index :subscriptions, :project_id
  end
end
