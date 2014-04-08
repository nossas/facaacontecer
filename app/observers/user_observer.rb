module UserObserver
  extend ActiveSupport::Concern


  included do
    # Hack due to MEURIO ACCOUNTS foreign table
    before_create :find_next_val_for_id, if: -> { Rails.env.production? }

    # Build invite when creating a new user
    before_save { self.build_invite unless self.invite.present? } 


    def find_next_val_for_id
      self.id = User.last.id.next 
    end


  end
end
