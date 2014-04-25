module PaymentObserver
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  included do
    before_create :setup_code
    after_create  :send_created_payment_email_slip,   if: -> { self.subscription.slip? }
    after_create  :send_created_payment_email_debit,  if: -> { self.subscription.debit? }
    after_save    :update_mailchimp_user_data,        unless: -> { self.subscription.creditcard? }
    after_save    :update_mailchimp_user_segment,     unless: -> { self.subscription.creditcard? }

    def update_mailchimp_user_data
      self.delay.update_user_data(
        retry_link: retry_payment_url(self),
        payments_count: self.user.payments.successful.count,
        last_payment_created_at: self.user.payments.successful.order(:created_at).last.try(:created_at),
        payment_value: self.subscription.value,
        payment_option: self.subscription.payment_option
      )
    end

    def update_mailchimp_user_segment
      self.delay.add_to_single_payment_segment(self.user.email, self.state)
    end

    # SETUP an unique code for each payment, after its creation
    # All subscriptions have only integer code
    # All payments (except creditcard) have a PAYMENT suffix after the subscription code
    # E.g.:
    #   int: 123456        is the subscription
    #   int + string: 123456PAYMENT is the payment for boleto and debito
    #   int: 123123 is the payment for creditcard
    def setup_code
      self.code = "#{self.subscription.code}_#{self.subscription.payments.count}_PAYMENT"
    end



    # Deliver an email with payment links when slip
    def send_created_payment_email_slip
      return false unless self.url
      Notifications::PaymentMailer.delay.created_payment_slip(self.id)
    end



    # Deliver an email with payment links when debit
    def send_created_payment_email_debit
      return false unless self.url
      Notifications::PaymentMailer.delay.created_payment_debit(self.id)
    end

    # Deliver an email informing that the payment is being processed
    def notify_user
      Notifications::PaymentMailer.delay.processing_payment(self.id)
    end




    # Deliver an email informating the user's INVITER that he won a prize
    # if present, of course
    def notify_inviter
      inviter = self.user.invite.host

      # TODO: Only send the notify inviter email once for
      if inviter and has_only_one_authorized_payment?
        Notifications::InviteMailer.delay.created_guest(self.user.id, inviter.id)
      end
    end



    # Check if the current subscription has already on payment authorized
    # So we can avoid sending the INVITE email to the INVITER Twice.
    def has_only_one_authorized_payment?
      Payment.where(state: :authorized, subscription: self.subscription).count.to_i == 1
    end



    # After the finish event for a payment, activate the parent subscription
    # And send activated_subscription_email
    def activate_subscription
      self.update_attribute(:paid_at, Time.now)
      # self.subscription.activate! if !self.subscription.creditcard?
      Notifications::PaymentMailer.delay.authorized_payment(self.id)
    end



    # After the Refund/ Reverse action in a payment, Pause the subscription
    # And send paused_subscription_email
    def pause_subscription
      # self.subscription.pause! if !self.subscription.creditcard?
    end



    # Notify a refund or reverse action when the user requests it
    def notify_refund
      nil
    end



    # Notify a user when a payment is cancelled
    def notify_cancelation
      Notifications::PaymentMailer.delay.cancelled_payment(self.id)
    end

    # Placing all callbacks inside the observer, instead of
    # Putting it on states file. This way we can keep things organized.
    # States where states should be; Callbacks (observers) where they should be as well.
    state_machine do
      after_transition on: :authorize,          do: [:activate_subscription, :notify_inviter]
      after_transition on: :cancel,             do: [:pause_subscription, :notify_cancelation]
      after_transition on: :wait,               do: [:notify_user]
      after_transition on: [:reverse, :refund], do: [:pause_subscription, :notify_refund]
    end
  end
end
