require 'spec_helper'


describe Notifications::PaymentsController do


  before do
    @payment = Fabricate(:payment)
    @payment.subscription.wait_confirmation!
    # The request send by NASP service from MOIP
    # accordingly with their documentation
    # See: https://labs.moip.com.br/referencia/nasp/#notificacao
    @nasp_params = {
      :id_transacao       => @payment.code,
      :valor              => @payment.subscription.value,
      :status_pagamento   => "4", # finished
      :cod_moip           => "12345678",
      :forma_pagamento    => "3",
      :tipo_pagamento     => "BoletoBancario",
      :parcelas           => "1",
      :email_consumidor   => @payment.user.email,
      :classificacao      => "Solicitado pelo vendedor"
    }

  end


  describe "#states" do
    subject { @payment.reload }

    context "When a payment instruction is sent with status 'EmAnalise'" do
      before do
        @nasp_params[:status_pagamento] = '6'
        post :create, @nasp_params
        Sidekiq::Extensions::DelayedMailer.drain
      end


      it { expect(response.status).to eq(302) }
      its(:subscription) { expect(subject.subscription.state).to eq('waiting') }
      its(:state) { should == 'waiting' }
      it "should send an PAYMENT PROCESSING email to the payer" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([@payment.user.email])
      end
    end




    context "When a payment instruction is sent with status 'Estornado'" do
      before do
        @nasp_params[:status_pagamento] = "7"
        post :create, @nasp_params
      end


      it { expect(response.status).to eq(302) }
      its(:subscription) { subject.subscription.state.should == 'paused' }
      its(:state) { should == 'reversed' }
    end

    context "When a payment instruction is sent with status 'BoletoImpresso'" do 
      before do
        @nasp_params[:status_pagamento] = "3"
        post :create, @nasp_params
      end

      it { expect(response.status).to eq(302) }
      its(:subscription) { subject.subscription.state.should == 'waiting' }
      its(:state) { should == 'printed' }

    end


    context "When a payment instruction is sent with status 'Cancelado'" do
      before do
        @nasp_params[:status_pagamento] = "5"
        post :create, @nasp_params
      end

      it { expect(response.status).to eq(302) }
      its(:subscription) { subject.subscription.state.should == 'paused' }
      its(:state) { should == 'cancelled' }

    end



    context "When a payment instruction is sent with status 'concluído'" do

      before do
        post :create, @nasp_params
        Sidekiq::Extensions::DelayedMailer.drain
      end

      it { expect(response.status).to eq(302) }
      its(:state) { should == 'finished' } 
      its(:subscription) { expect(subject.subscription.reload.state).to eq("active") }

      it "should send an PAYMENT APPROVED email to the payer" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([@payment.user.email])
      end

    end



  end
end
