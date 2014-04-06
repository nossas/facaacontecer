require 'spec_helper'

describe SubscriptionsController do
  let(:subscription) { Fabricate(:subscription, payment_option: 'slip')}

  describe "GET #show" do
    before { subscription.payments.create(url: 'sample') }

    context "When the subscription status is 'waiting'" do
      before do
        subscription.wait_confirmation
        get :show, id: subscription.id
      end
      it { expect(response).to redirect_to(payment_path(subscription.payments.last)) }
    end


    context "When the subscription status is 'processing'" do
      before { get :show, id: subscription.id }

      it { expect(response).not_to redirect_to(payment_path(subscription.payments.last)) }
    end
  end


  describe "GET #confirm" do
    before do
      @subscription = Fabricate(:subscription, payment_option: "creditcard")
      get :confirm, id: @subscription.id
    end

    #it { expect(response).to eq(200) }
    #it { expect(response.body).to eq(nil) }
    it { expect(@subscription.reload.state).to eq('waiting') }

  end

end
