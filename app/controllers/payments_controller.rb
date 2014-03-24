class PaymentsController < ApplicationController

  before_actions do
    actions(:show) { @payment = Payment.find_by(id: params[:id]) }
  end

  def show; end
end
