require 'spec_helper'


describe PaymentsController do
  let(:payment) { Fabricate(:payment) }

  describe "GET #show" do
    before do
      get :show, id: payment.id
    end

    it { expect(response.status).to eq(200) }
    it "should associate any invite with the current payment's user" do
      expect(payment.user.invite.host).to eq(nil)
    end
  end

  context "When a user paid through another user's invite code" do
    before do
      @user = Fabricate(:user)
      session[:code] = @user.invite.code
      get :show, id: payment.id
    end

    it { expect(response.status).to eq(200) }
    it "should associate the current user invite with the INVITER code" do
      expect(payment.user.invite.reload.host).to eq(@user)
    end
  end

end
