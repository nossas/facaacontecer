require 'spec_helper'

describe WebhooksController do



  describe "GET #bankslip" do
    
    context "When no authorization token is found" do
      it "should redirect to root path" do
        get :bankslips
        expect(response).to redirect_to(root_path)
      end
    end

    context "When a invalid authorization token is found" do
      it "should redirect_to root_path" do
        ENV['ADMIN_UNIQUE_TOKEN'] = '123'
        get :bankslips, token: '1234'
        expect(response).to redirect_to(root_path)
      end
    end


    context "When a valid authorization token is found" do
      before do 
        ENV['ADMIN_UNIQUE_TOKEN'] = '123'
        get :bankslips, token: '123'
      end

      it "should not redirect" do
        expect(response).not_to redirect_to(root_path)
      end


      it "should fetch all Boleto (bank slips) subscriptions" do
        Subscription.should_receive(:where).with(payment_option: 'boleto').and_return(ActiveRecord::Relation)
      end
    end


  end

end

