require 'spec_helper'

describe SubscriptionsController do
  

  describe "GET #show" do
    before { @subscription = Fabricate(:subscription, payment_option: 'slip') }


    context "When the subscription status is 'waiting'" do
      before do
        @subscription.wait_confirmation
        get :show, id: @subscription.id
      end
      it { expect(response).to redirect_to(confirming_subscription_path(@subscription)) }
    end


    context "When the subscription status is 'processing'" do
      before { get :show, id: @subscription.id }

      it { expect(response).not_to redirect_to(confirming_subscription_path(@subscription)) }
    end



  end

end
