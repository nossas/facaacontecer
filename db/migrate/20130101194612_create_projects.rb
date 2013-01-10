class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.date :expiration_date
      t.decimal :goal
      t.string :image
      t.string :video

      t.timestamps
    end
  end
end
