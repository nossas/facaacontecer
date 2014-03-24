require 'spec_helper'

describe SubscriptionsController do
  

  describe "GET #show" do
    before { @subscription = Fabricate(:subscription, payment_option: 'slip') }
    before { @subscription.payments.create(url: 'sample') }

    context "When the subscription status is 'waiting'" do
      before do
        @subscription.wait_confirmation
        get :show, id: @subscription.id
      end
      it { expect(response).to redirect_to(payment_path(@subscription.payments.last)) }
    end


    context "When the subscription status is 'processing'" do
      before { get :show, id: @subscription.id }

      it { expect(response).not_to redirect_to(payment_path(@subscription.payments.last)) }
    end



  end

end
