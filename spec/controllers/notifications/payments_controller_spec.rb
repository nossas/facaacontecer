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
      :tipo_pagamento     => "CartaoDeCredito",
      :parcelas           => "1",
      :email_consumidor   => @payment.user.email,
      :classificacao      => "Solicitado pelo vendedor"
    }
  end



  context "When a payment instruction is sent with status 'finished'" do
    before do
      post :create, @nasp_params
    end
    it { expect(response.status).to eq(302) }
    it { expect(@payment.reload.state).to eq("finished") }
    it { expect(@payment.subscription.reload.state).to eq("active") }
  end


end
