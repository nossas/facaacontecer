class AddPostalCodeToUser < ActiveRecord::Migration
  def change
    if Rails.env.production? || Rails.env.staging?
      add_column :users, :postal_code, :string
    end
  end
end
