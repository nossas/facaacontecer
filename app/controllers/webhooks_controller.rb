class WebhooksController < ApplicationController 



  before_filter only: [:bankslips] do 
    redirect_to root_path unless params[:date] && params[:date].to_date.future? 
  end

  before_filter only: [:subscription_status, :status] do
    # From 1 to 8. 0 is empty code
    @codes = ['', 'authorized', 'started', 'printed', 'done', 'canceled', 'waiting', 'reversed', 'refunded']

  end



  def subscription_status
    return render nothing: true, status: 406, content_type: 'application/json' unless params[:event] 

    if params[:event] == 'payment.created'
      @subscription = Subscription.find_by_code(params[:resource][:subscription_code])
      if @subscription.present?
        @payment = PaymentInstruction.new do |c|
          c.code = params[:resource][:id]
          c.status = 'started'
          c.subscription = @subscription
          c.save!
        end
      else 
        return redirect_to root_path
      end

    elsif params[:event] == 'payment.status_updated'
      @payment = PaymentInstruction.find_by_code(params[:resource][:id].to_s)
      if @payment.present?
        @payment.status   = @codes[params[:resource][:status][:code].to_i]
        @payment.paid_at  = Time.now if params[:resource][:status][:code].to_i == 3 or params[:resource][:status][:code].to_i == 4
        @payment.save!
      else
        return redirect_to root_path
      end
    end

    return render nothing: true, status: 200, content_type: 'application/json'

  end

  def status

    instruction = PaymentInstruction.find_by_code(params[:id_transacao])
    instruction.status = @codes[params[:status_pagamento].to_i]
    instruction.paid_at = Time.now if params[:status_pagamento].to_i == 4 
    instruction.save!

    render nothing: true, status: 200, content_type: 'text/html'
  end



  def bankslips

    @subscriptions = Project.find_by_id(params[:project]).subscriptions.where(payment_option: :boleto, status: :active)
    @date          = params[:date]
    @sequence      = SecureRandom.hex(4) 

    @subscriptions.each do |s|
      s.delay.send_payment_request(@date.to_time.strftime("%Y-%m-%dT%H:%M:%S%:z"), @sequence)
    end
    render nil, body: "Enviando...", status: 200
  end







end
