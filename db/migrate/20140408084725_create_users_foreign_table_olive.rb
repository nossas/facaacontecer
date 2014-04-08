class CreateUsersForeignTableOlive < ActiveRecord::Migration
  def up
    if Rails.env.production? || Rails.env.staging?
      # execute 'DROP FOREIGN TABLE users;'
    else
      execute 'DROP TABLE users;'
    end

    if Rails.env.production? || Rails.env.staging?
      execute(
      %Q{
        CREATE FOREIGN TABLE users(
        id serial,
        first_name character varying(255) NOT NULL,
        last_name character varying(255) NOT NULL,
        email character varying(255) NOT NULL,
        cpf character varying(255),
        birthday date NOT NULL,
        address_street character varying(255) NOT NULL,
        address_extra character varying(255) NOT NULL,
        address_number character varying(255),
        address_district character varying(255),
        city character varying(255),
        state character varying(5),
        country character varying(50),
        phone character varying(255)
        )
        SERVER meurio_accounts
        OPTIONS (table_name 'users');
      }
      )
    else
      create_table :users do |t|
        t.string :first_name, null: false
        t.string :last_name, null: false
        t.string :email, null: false
        t.string :cpf
        t.date   :birthday, null: false
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

    end
  end

  def down
    if Rails.env.production? || Rails.env.staging?
      execute 'DROP FOREIGN TABLE users;'
    else
      execute 'DROP TABLE users;'
    end
  end
end
