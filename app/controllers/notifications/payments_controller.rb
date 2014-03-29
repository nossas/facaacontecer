class Notifications::PaymentsController < ApplicationController

  # Located @ app/controllers/notifications/concerns/payment_status.rb
  include Notifications::PaymentStatus

  before_actions do
    actions(:create) do
      @payment = Payment.find_by(code: _params[:code])
      render_nothing_with_status(500) if @payment.nil?
    end
  end


  # POST /notifications/payments
  def create

    # using the mapped :state param as a state call.
    @payment.send(_params[:state].to_s)
    render_nothing_with_status(302)
  end



  # Mapping all params received to the PaymentStatus concern
  def _params
    # Located @ app/controllers/concerns/notifications/payment_status
    return payment_params(params)
  end


  # Avoiding repetition
  def render_nothing_with_status(status)
    return render nothing: true, status: status.to_i
  end


end
