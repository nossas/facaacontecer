module UserObserver
  extend ActiveSupport::Concern


  included do
    # Build invite when creating a new user
    before_create { self.build_invite } 


  end
end
