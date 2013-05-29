# coding: utf-8
class SubscriptionsController < ApplicationController
  inherit_resources
  actions :create, :create_with_bank_slip

  before_filter only: [:create, :create_with_bank_slip] do
    @subscription             = Subscription.new(params[:subscription])
    @subscription.project     = Project.find(params[:project_id])
    @subscription.subscriber  = User.find(params[:subscriber_id])
    @subscription.status      = :active 
  end

  append_before_filter only: [:create_with_bank_slip] do
    @subscription.payment_option  = :boleto
    @subscription.code            = SecureRandom.hex(8) 
  end


  after_filter  only: [:create, :create_with_bank_slip] do 
    session[:subscriber_ok] = true
    send_successful_message
    send_invite_email
  end

  def create
    create! { thank_you_path(@subscription.subscriber) } 
  end


  def create_with_bank_slip
    if send_payment_request && @subscription.save!
      session[:token] = @transparent_request.token
      return redirect_to thank_you_path(@subscription.subscriber)
    end

    return render json: { body: @subscription.errors, status: :unprocessable_entity }
  end



  private
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
