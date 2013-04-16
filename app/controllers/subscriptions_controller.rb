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


  after_filter  only: [:create] { SubscriptionMailer.successful_create_message_for_249_to_500(@subscription).deliver }
  after_filter  only: [:create_with_bank_slip] { SubscriptionMailer.successful_create_message_for_249_to_500(@subscription).deliver }
  after_filter  only: [:create, :create_with_bank_slip] { SubscriptionMailer.inviter_friend_subscribed(@subscription) if @subscription.subscriber.invite.host.present? } 
  after_filter  only: [:create, :create_with_bank_slip] { session[:subscriber_ok] = true }

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
      @payment.api_call(@subscription.bankslip, token: @transparent_request.token)
      @payment.success?
    end

end
