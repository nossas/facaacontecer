class WebhooksController < ApplicationController 


  respond_to :csv

  before_filter only: [:bankslips] do
    redirect_to root_path unless params[:token] && ENV['ADMIN_UNIQUE_TOKEN'] == params[:token] && params[:project] && params[:date]
    redirect_to root_path unless params[:date].to_date.future? 
  end


  def status
    # From 1 to 8. 0 is empty code
    codes = ['', 'authorized', 'started', 'printed', 'done', 'canceled', 'waiting', 'reversed', 'refunded']

    instruction = PaymentInstruction.find_by_code(params[:id_transacao])
    instruction.status = codes[params[:status_pagamento].to_i]
    instruction.paid_at = params[:status_pagamento].to_i == 1 or params[:status_pagamento].to_i == 4 ? Time.now : nil
    instruction.save!

    render nil, status: 200
  end



  def bankslips

    @subscriptions = Project.find_by_id(params[:project]).subscriptions.where(payment_option: :boleto, status: :active)
    @date          = params[:date]
    

    respond_to do |format|
      format.csv {
        

        @filename = "boletos-#{@date}.csv"
        self.response.headers["Content-Type"] ||= 'text/csv'
        self.response.headers["Content-Disposition"] = "attachment; filename=#{@filename}"
        self.response.headers['Last-Modified'] = Time.now.ctime.to_s
        self.response.headers["Content-Transfer-Encoding"] = "binary"

        # theoretically this should make unicorn pass-through
        #headers['X-Accel-Buffering'] = 'no'
        self.status = 200
        self.response_body = Enumerator.new do |line|
          i = 0

          @subscriptions.each do |s|
            if i == 0
              line << "Nome, Link\n"
            end

          
            if send_payment_request(s, @date.to_time.strftime("%Y-%m-%dT%H:%M:%S%:z")) && get_request_sent?
              line << "#{s.subscriber.name}, #{@url}\n"
            else
              line << "#{s.subscriber.name}, Erro: subscription ##{s.id}\n"
            end

            i += 1
            GC.start if i%500 == 0
          end
         end

      }
    end
  end


  def get_request_sent?
    @url     = MOIP_INSTRUCTION_URL + @transparent_request.token
    HTTParty.get(@url)
  end

  def create_payment_instruction(subscription, code)

    payment = PaymentInstruction.new do |p|
      p.status        = nil
      p.subscription  = subscription
      p.expires_at    = nil
      p.code          = code
      p.expires_at    = Time.now + 10.days
      p.url           = MOIP_INSTRUCTION_URL + @transparent_request.token
    end

    payment.save!
  end


  def send_payment_request(subscription, date)
    instruction = subscription.prepared_instruction 

    @transparent_request = MyMoip::TransparentRequest.new(subscription.code)
    @transparent_request.api_call(instruction)

    @payment = MyMoip::PaymentRequest.new(subscription.code)
    @payment.api_call(subscription.bankslip(expiration: date), token: @transparent_request.token)
   
    create_payment_instruction(subscription, instruction.id) if @payment.success?
    @payment.success?
  end



end
