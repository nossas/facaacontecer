module SubscriptionObserver
  extend ActiveSupport::Concern

  included do
    before_create { self.code = "#{self.user_id}_#{Time.now.to_i}" }
    before_save { self.state_updated_at = Time.now if self.state_changed? }

    # TODO it should run only when state changes
    after_save do
      self.delay.update_user_data(
        plan: self.plan,
        subscription_value: self.value,
        state_updated_at: self.state_updated_at.try(:strftime, "%m/%d/%Y")
      )

      self.delay.add_to_subscription_segment(self.user.email, self.state)
    end
  end
end
