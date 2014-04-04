class PaymentsController < ApplicationController

  before_actions do
    actions(:show) { @payment = Payment.find_by(id: params[:id]) }
  end
  
  force_ssl if: :ssl_configured?

  def show; end
end
