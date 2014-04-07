require 'spec_helper'


describe Notifications::PaymentsController do

  def post_with_payment_status(status = "1") 
    @nasp_params[:status_pagamento] = status
    post :create, @nasp_params
  end

  def run_workers!
    Sidekiq::Extensions::DelayedMailer.drain
  end

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
        post_with_payment_status("6")
        run_workers!
      end


      it { expect(response.status).to eq(200) }
      its(:subscription) { expect(subject.subscription.state).to eq('waiting') }
      its(:state) { should == 'waiting' }
      it "should send an PAYMENT PROCESSING email to the payer" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([@payment.user.email])
      end
    end




    context "When a payment instruction is sent with status 'Estornado'" do
      before do
        post_with_payment_status("7")
      end


      it { expect(response.status).to eq(200) }
      its(:subscription) { subject.subscription.state.should == 'paused' }
      its(:state) { should == 'reversed' }
    end

    context "When a payment instruction is sent with status 'BoletoImpresso'" do 
      before do
        post_with_payment_status("3")
      end

      it { expect(response.status).to eq(200) }
      its(:subscription) { subject.subscription.state.should == 'waiting' }
      its(:state) { should == 'printed' }

    end


    context "When a payment instruction is sent with status 'Cancelado'" do
      before do
        post_with_payment_status("5")
        run_workers!
      end

      it { expect(response.status).to eq(200) }
      its(:subscription) { subject.subscription.state.should == 'paused' }
      its(:state) { should == 'cancelled' }

      it "should send an Email informing the user about the cancellation" do
        expect(ActionMailer::Base.deliveries.last.subject).to eq("[MeuRio] Oops, houve um problema com a sua doação")
        expect(ActionMailer::Base.deliveries.last.to).to eq([@payment.user.email])
      end
    end



    context "When a payment instruction was sent with status 'Autorizado'" do

      before do
        post_with_payment_status("1")
        run_workers!
      end


      it { expect(response.status).to eq(200) }
      its(:state) { should == 'authorized' } 
      its(:paid_at) { should_not == nil }
      its(:subscription) { expect(subject.subscription.reload.state).to eq("active") }

      it "should send an PAYMENT APPROVED email to the payer" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([@payment.user.email])
      end
    end

    context "When a payment instruction was sent with status 'Autorizado' and the payment's user has 1 inviter/host" do
      before do
        @host = Fabricate(:user, email: 'host@email.com')
        @payment.user.invite.update_attribute(:host, @host)
        @payment.subscription.update_attribute(:payment_option, 'creditcard')
        post_with_payment_status("1")
        run_workers!
        
      end 
      it { expect(response.status).to eq(200) }
      it { expect(@payment.reload.has_only_one_authorized_payment?).to eq true }
      it {
        expect(ActionMailer::Base.deliveries.last.to).to eq([@host.email])
      }
      it { 
        expect(ActionMailer::Base.deliveries.last.subject).to eq("[MeuRio] Você ganhou uma camiseta da Rede Meu Rio!")
      }

    end

    context %Q{
      When a payment instruction was sent with status 'Autorizado'
      and the payment's user has 1 inviter/host and 2 other AUTHORIZED payments} do
      before do
        @payment.user.invite.update_attribute(:host, @host)
        @host = Fabricate(:user, email: 'host@email.com')
        2.times { Fabricate(:payment, state: :authorized, subscription: @payment.subscription) }

        post_with_payment_status("1")
        run_workers!
        
      end 

      it { expect(response.status).to eq(200) }
      it {
        expect(ActionMailer::Base.deliveries.last.to).to_not eq([@host.email])
      }
      it { 
        expect(ActionMailer::Base.deliveries.last.subject).to_not eq("[MeuRio] Você ganhou uma camiseta da Rede Meu Rio!")
      }

      it { expect(@payment.has_only_one_authorized_payment?).to eq false }
    end


  end
end
