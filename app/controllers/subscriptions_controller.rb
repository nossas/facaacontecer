class SubscriptionsController < ApplicationController

  before_actions do
   
    actions(:create_with_bank_slip) do
      @subscription.payment_option  = :boleto
      @subscription.code            = SecureRandom.hex(8) 
    end

    actions(:create, :create_with_bank_slip) do 
      @subscription = Subscription.new(subscription_params)
      @subscription.project     = Project.find_by(id: params[:project_id])
      @subscription.subscriber  = User.find_by(id: params[:subscriber_id])
      @subscription.status = :active 
    end


    #actions(:update) { @subscription = Subscription.find_by(id: params[:id]) }
  end

  def create
    if @subscription.save
      deliver_notification_emails 
      redirect_to thank_you_path(@subscription.subscriber)
    end
  end

  def create_with_bank_slip
    if send_payment_request && @subscription.save!
      session[:token] = @transparent_request.token
      return redirect_to thank_you_path(@subscription.subscriber)
    end

    return render json: { body: @subscription.errors, status: :unprocessable_entity }
  end



  private
    def subscription_params
      if params[:subscription]
        params.require(:subscription).permit(%i(
          code value gift anonymous status payment_option))
      else 
        {}
      end
    end


    def deliver_notification_emails
      session[:subscriber_ok] = true
      send_successful_message
      send_invite_email
    end




    # TODO:
    # Move all things below to a business class
    def send_payment_request 
      @transparent_request = MyMoip::TransparentRecurringRequest.new(@subscription.code)
      @transparent_request.api_call(@subscription.prepared_instruction)

      @payment = MyMoip::PaymentRequest.new(@subscription.code)
      @payment.api_call(@subscription.bankslip(expiration: Time.now + 10.days), token: @transparent_request.token)
      @payment.success?
    end


    def send_successful_message
      return SubscriptionMailer.after_campaign_ending(@subscription).deliver if @subscription.project.expired?

      if @subscription.project.subscribers.size > 500
        return SubscriptionMailer.successful_create_message_for_500_to_1000(@subscription).deliver
      end

      return SubscriptionMailer.successful_create_message_for_249_to_500(@subscription).deliver
    end


    def send_invite_email
      @host = @subscription.subscriber.invite.host
      return nil unless @host.present?

      if @host.invitees.size == 5
        SubscriptionMailer.successful_invited_5_friends(@subscription).deliver
      else
        SubscriptionMailer.inviter_friend_subscribed(@subscription).deliver         
      end
    end
end
