class WebhooksController < ApplicationController 



  before_filter only: [:bankslips] do 
    redirect_to root_path unless params[:date].to_date.future? 
  end


  def status
    # From 1 to 8. 0 is empty code
    codes = ['', 'authorized', 'started', 'printed', 'done', 'canceled', 'waiting', 'reversed', 'refunded']

    instruction = PaymentInstruction.find_by_code(params[:id_transacao])
    instruction.status = codes[params[:status_pagamento].to_i]
    instruction.paid_at = Time.now if params[:status_pagamento].to_i == 1 or params[:status_pagamento].to_i == 4
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
