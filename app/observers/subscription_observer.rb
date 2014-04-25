module SubscriptionObserver
  extend ActiveSupport::Concern

  included do
    before_create { self.code = "#{self.user_id}_#{Time.now.to_i}" }
    before_save { self.state_updated_at = Time.now if self.state_changed? }
    after_save :update_mailchimp_user_data, if: -> { self.creditcard? }
    after_save :update_mailchimp_user_segment, if: -> { self.creditcard? }

    def update_mailchimp_user_data
      self.delay.update_user_data(
        plan: self.plan,
        subscription_value: self.value,
        state_updated_at: self.state_updated_at.try(:strftime, "%m/%d/%Y")
      )
    end

    def update_mailchimp_user_segment
      self.delay.add_to_subscription_segment(self.user.email, self.state)
    end
  end
end
