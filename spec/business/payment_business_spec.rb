require 'spec_helper'
describe PaymentBusiness do


  describe "#instruction" do
    before do
      MOIP_NOTIFICATIONS_HOST = 'example.com'

      @subscription = Fabricate(:subscription)
    end
    it "should return a MyMoip Instruction object" do
      expect(@subscription.boleto.instruction).to be_a_kind_of(MyMoip::Instruction)
    end

    it "setup a notification url" do
      expect(@subscription.boleto.instruction.notification_url).to eq("http://example.com/notifications/payments")
    end

  end






end
