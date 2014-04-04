class Notifications::PaymentsController < ApplicationController

  # Located @ app/controllers/notifications/concerns/payment_status.rb
  include Notifications::PaymentStatus

  # Find a payment or render nothing if not found
  before_actions do
    actions(:create) do
      @payment = Payment.find_by(code: _params[:code])
      render_nothing_with_status(500) if @payment.nil?
    end
  end



end
