class PaymentsController < ApplicationController

  before_actions do
    actions(:show) { @payment = Payment.find_by(id: params[:id]) }

    # If the session[:code] was present when the
    # user did his subscription, associate
    # the invite with the user & its inviter
    actions(:show) { associate_invite_if_present }
  end

  # Force SSL on the controller
  force_ssl if: :ssl_configured?


  # GET /payments/:id
  def show; end

  def retry
    @payment = Payment.find(params[:id])
    if request.post?
      redirect_to Payment.create(subscription_id: @payment.subscription_id)
    else
      render :retry
    end
  end

  private
    # 1. Associate an invite an user have with the session code provided
    #    When a user clicks on another's user invite.
    #    The url is http:/yoursite.com/invite/:code
    #
    # - This callback happens when the user has a subscription waiting for confirmation
    # - and actually is willing to donate.
    #
    # 2. After that, the user receives a T-SHIRT (and an email) when
    #   this payment state is AUTHORIZED
    #
    # 3. Go check app/observers/payment_observer
    def associate_invite_if_present
      return nil unless session[:code].present?

      # Find the host/inviter
      host = Invite.find_by(code: session[:code])

      if host
        # Update the host attribute of this payment's user
        @payment.user.invite.update_attributes(host: host.user)
      end
    end
end
