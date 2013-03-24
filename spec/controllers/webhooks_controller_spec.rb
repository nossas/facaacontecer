require 'spec_helper'


describe WebhooksController do


  describe "POST #subscription" do

    context "When there is an authorization token from MOIP" do
      it "should return HTTP found status, 302" do
        controller.stub(:authorization?).and_return(true)
        post :subscription

        expect(response.status).to eq(302)
      end
    end


    context "When there aren't an authorization token from MOIP" do
      it "should return HTTP unauthorized status, 401" do
        controller.stub(:authorization?).and_return(false)
        post :subscription
        expect(response.status).to eq(401)
      end
    end


  end


end
