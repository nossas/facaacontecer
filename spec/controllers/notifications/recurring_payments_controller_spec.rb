require 'spec_helper'


describe Notifications::RecurringPaymentsController do
  describe "POST create" do
    context "when it's an invoice event" do
      it "should call the create_or_update_invoice method" do
        http_params = { event: "invoice.*", resource: { id: 1 }, date: "31/03/2014 14:55:21" }

        Notifications::RecurringPaymentsController.
        any_instance.
        should_receive(:create_or_update_invoice).
        with({ "id" => "1" }, "31/03/2014 14:55:21")

        post :create, http_params
      end
    end

    context "when it's a subscription event" do
      it "should call the update_subscription_state method" do
        subscription = Fabricate(:subscription)

        @http_params =  {
          event: "subscription.created",
          resource: { code: subscription.code, status: "ACTIVE" }
        }

        Notifications::RecurringPaymentsController.
        any_instance.
        should_receive(:update_subscription_state).
        with(subscription.code, "ACTIVE", "subscription.created")

        post :create, @http_params
      end
    end

    context "when it's a payment.status_updated event" do
      before do
        @subscription = Fabricate(:subscription)
        @subscription.wait_confirmation!

        # The request send by NASP service from MOIP
        # accordingly with their documentation
        # See: https://labs.moip.com.br/referencia/nasp/#notificacao
        # See: http://moiplabs.github.io/assinaturas-docs/api.html#status_pagamento
        @http_params =  {
          :"event" => "payment.status_updated",
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
  end

  describe "#update_subscription_state" do
    let(:subscription){ double("subscription") }
    before { Subscription.stub(:find_by_code).and_return(subscription) }

    context "when it's the created event" do
      let(:event){ "subscription.created" }

      context "when the status is ACTIVE" do
        let(:status){ "ACTIVE" }
        it "should update the subscription state to active" do
          subscription.should_receive(:update_attributes).with(state: "active")
          subject.send(:update_subscription_state, "123", status, event)
        end
      end

      context "when the status is SUSPENDED" do
        let(:status){ "SUSPENDED" }
        it "should update the subscription state to suspended" do
          subscription.should_receive(:update_attributes).with(state: "suspended")
          subject.send(:update_subscription_state, "123", status, event)
        end
      end

      context "when the status is OVERDUE" do
        let(:status){ "OVERDUE" }
        it "should update the subscription state to overdue" do
          subscription.should_receive(:update_attributes).with(state: "overdue")
          subject.send(:update_subscription_state, "123", status, event)
        end
      end

      context "when the status is CANCELED" do
        let(:status){ "CANCELED" }
        it "should update the subscription state to canceled" do
          subscription.should_receive(:update_attributes).with(state: "canceled")
          subject.send(:update_subscription_state, "123", status, event)
        end
      end
    end

    context "when it's the suspended event" do
      let(:event){ "subscription.suspended" }

      it "should update the subscription state to suspended" do
        subscription.should_receive(:update_attributes).with(state: "suspended")
        subject.send(:update_subscription_state, "123", nil, event)
      end
    end

    context "when it's the activated event" do
      let(:event){ "subscription.activated" }

      it "should update the subscription state to active" do
        subscription.should_receive(:update_attributes).with(state: "active")
        subject.send(:update_subscription_state, "123", nil, event)
      end
    end

    context "when it's the canceled event" do
      let(:event){ "subscription.canceled" }

      it "should update the subscription state to canceled" do
        subscription.should_receive(:update_attributes).with(state: "canceled")
        subject.send(:update_subscription_state, "123", nil, event)
      end
    end
  end

  describe "#create_or_update_invoice" do
    let(:subscription) { Fabricate(:subscription) }

    context "when it's a new invoice" do
      let(:date) { "31/03/2014 14:55:21" }
      let(:resource){{
        "id" => 13,
        "subscription_code" => subscription.code,
        "amount" => 100,
        "occurrence" => 1,
        "status" => { "code" => 1, "description" => "Em aberto" }
      }}

      it "should create the new invoice" do
        Invoice.should_receive(:create!).with(
          uid: 13,
          subscription_id: subscription.id,
          value: 1.0,
          occurrence: 1,
          status: "started",
          created_on_moip_at: date
        )

        subject.send(:create_or_update_invoice, resource, date)
      end
    end

    context "when it's an existing invoice" do
      let(:invoice) { double("invoice") }
      let(:date) { "31/03/2014 14:55:21" }
      let(:resource){{
        "id" => 1,
        "status" => { "code" => 2 }
      }}

      it "should update the existing invoice" do
        invoice.should_receive(:update_attributes!).with(status: "waiting", created_on_moip_at: date)
        Invoice.stub(:find_by).with(uid: 1).and_return(invoice)
        subject.send(:create_or_update_invoice, resource, date)
      end
    end
  end
end
