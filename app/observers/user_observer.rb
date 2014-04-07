module UserObserver
  extend ActiveSupport::Concern


  included do
    # Hack due to MEURIO ACCOUNTS foreign table
    before_create :find_next_val_for_id, if: -> { Rails.env.production? }

    # Build invite when creating a new user
    before_create { self.build_invite } 


    def find_next_val_for_id
     next_id = raw_sql %Q{select (id + 1) from users order by id desc limit 1}
     self.id = next_id.to_i
    end

    def raw_sql(sql)
      ActiveRecord::Base.connection.execute(sql).to_a.first["id"]
    end

  end
end
