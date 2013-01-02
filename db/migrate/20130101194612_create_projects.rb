class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.decimal :goal
      t.datetime :expiration_date
      t.string :image
      t.string :video

      t.timestamps
    end
  end
end
