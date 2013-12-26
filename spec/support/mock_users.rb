RSpec.configure do |config|
  config.before do
    ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS users;")
    ActiveRecord::Base.connection.execute("
      CREATE TABLE IF NOT EXISTS users(
        id                SERIAL PRIMARY KEY, 
        created_at        timestamp without time zone,
        email             varchar(40), 
        first_name        varchar(40), 
        last_name         varchar(40),
        admin             boolean,
        avatar            varchar(40),
        phone             varchar(40),
        birthday          date,
        address_street    character varying(255),
        address_extra     character varying(255),
        address_number    character varying(255),
        address_district  character varying(255),
        city              character varying(255),
        state             character varying(255),
        country           character varying(255),
        postal_code       character varying(255),
        cpf               character varying(255)
      );
    ")
    User.any_instance.stub(:avatar_url).and_return("/assets/default-avatar.png")
  end
end
