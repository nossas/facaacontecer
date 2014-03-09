class AddServerMeurio < ActiveRecord::Migration
    def up
        if Rails.env.production? || Rails.env.staging?
            raise "MEURIO_DBNAME is missing" if ENV["MEURIO_DBNAME"].nil?
            raise "MEURIO_DBHOST is missing" if ENV["MEURIO_DBHOST"].nil?
            raise "MEURIO_DBUSER is missing" if ENV["MEURIO_DBUSER"].nil?
            raise "MEURIO_DBPASS is missing" if ENV["MEURIO_DBPASS"].nil?
            execute "CREATE EXTENSION postgres_fdw;"
            execute "CREATE SERVER meurio FOREIGN DATA WRAPPER postgres_fdw OPTIONS (dbname '#{ENV["MEURIO_DBNAME"]}', host '#{ENV["MEURIO_DBHOST"]}');"
            execute "CREATE USER MAPPING for #{ENV["DB_USERNAME"]} SERVER meurio OPTIONS (user '#{ENV["MEURIO_DBUSER"]}', password '#{ENV["MEURIO_DBPASS"]}');"
        end
    end
    
    def down
        if Rails.env.production? || Rails.env.staging?
            execute "DROP EXTENSION postgres_fdw CASCADE;"
        end
    end
end