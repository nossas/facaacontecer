require 'spec_helper'


describe PaymentsController do

  describe "GET #show" do
    before do
      @payment = Fabricate(:payment)
      get :show, id: @payment.id
    end

    it { expect(response.status).to eq(200) }
  end

end
