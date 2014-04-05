module UserObserver
  extend ActiveSupport::Concern


  included do

    # After creation, associante an invite code to this current user/instance 
    after_create :generate_invite




    

    # Generate a invite code after the creation 
    # of an user. This code allow tracking of
    # who is inviting who in the system
    private
    def generate_invite
      invite = self.build_invite(code: SecureRandom.hex(6))
      invite.save!
    end


  end


end
