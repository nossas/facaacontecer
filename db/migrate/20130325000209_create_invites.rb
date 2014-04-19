class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :code
      t.integer :user_id
      t.integer :parent_user_id, foreign_key: false

      t.timestamps

    end
    add_index :invites, [:code, :user_id], unique: true
    add_index :invites, [:user_id, :parent_user_id]

  end
end
