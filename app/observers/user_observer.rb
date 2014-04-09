module UserObserver
  extend ActiveSupport::Concern

  included do
    # Hack due to MEURIO ACCOUNTS foreign table
    before_create :find_next_val_for_id, if: -> { Rails.env.production? }

    # Build invite when creating a new user
    before_save { self.build_invite unless self.invite.present? }

    after_create { self.delay.add_to_mailchimp_list }

    def find_next_val_for_id
      self.id = User.last.id.next
    end

    def add_to_mailchimp_list
      begin
        Gibbon::API.lists.subscribe(
          id: ENV["MAILCHIMP_LIST_ID"],
          email: { email: self.user.email },
          double_optin: false,
          update_existing: true,
          merge_vars: {
            FNAME: self.user.first_name,
            LNAME: self.user.last_name
          }
        )
      rescue Exception => e
        logger.error e.message
      end
    end
  end
end
