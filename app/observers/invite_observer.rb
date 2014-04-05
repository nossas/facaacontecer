module InviteObserver
  extend ActiveSupport::Concern


  included do
    # Associate an hexadecimal code when creating a new invite
    before_validation(on: :create) { self.code = SecureRandom.hex(6) } 


  end


end
