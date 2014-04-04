require 'spec_helper'


describe Notifications::RecurringPaymentsController do

  before do
    @subscription = Fabricate(:subscription)
    @subscription.wait_confirmation!

    # The request send by NASP service from MOIP
    # accordingly with their documentation
    # See: https://labs.moip.com.br/referencia/nasp/#notificacao
    # See: http://moiplabs.github.io/assinaturas-docs/api.html#status_pagamento
    @http_params =  {
      :"event" => "payment.created",
      :"date" => "14/12/2100 00:00:00",
      :"env" => "sandbox",
      :"resource" => {
        :"id" => "sample_id", # payment id
        :"invoice_id" => 13,
        :"moip_id" => "14456223",
        :"subscription_code" => @subscription.code,
        "amount" => 101,
        :"status" => {
          :"code" => 2,
          "description" => "Iniciado"
        },
        "payment_method" => {
          "code" => 1,
          "description" => "Cartão de Crédito",
          "credit_card" => { #enviado apenas se foi pago com cartão de crédito
            "brand" => "VISA",
            "holder_name" => "Fulano Testador",
            "first_six_digits" => "411111",
            "last_four_digits" => "1111",
            "vault" => "cc7719e7-9543-4380-bdfe-c14d0e3b8ec9"
          }
        }
      }
    }
  end



  describe "#states" do


    context "When a existing subscription receives a payment.created event" do
      before do
        post :create, @http_params
      end

      it { expect(response.status).to eq(200) }

      it "should create a payment object" do
        expect(@subscription.payments.last.code).to eq("sample_id") 
      end

      it "should initialize the payment with STARTED state" do
        expect(@subscription.payments.last.state).to eq('started')
      end
    end


    context "When a existing subscription receives a payment.status_update event with WAITING status" do
      before do
        @payment = Fabricate(:payment)
        @http_params[:event] = "payment.status_updated"
        @http_params[:resource][:id] = @payment.code
        @http_params[:resource][:status][:code] = "6"
        post :create, @http_params
      end
      
      it { expect(response.status).to eq(200) }

      it "should change the payment status to WAITING" do
        expect(@payment.reload.state).to eq('waiting')
      end
      
      it "should send an WAITING email" do
        Sidekiq::Extensions::DelayedMailer.drain
        expect(ActionMailer::Base.deliveries.last.to).to eq([@payment.user.email])
      end
    end






  end




end
