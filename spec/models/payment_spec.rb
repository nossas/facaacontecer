require 'spec_helper'

describe Payment do

  context "associations & validations" do
    it { should validate_presence_of :subscription }
    it { should belong_to :subscription } 
  end


  context "#after_create" do

    before do
      @payment = Fabricate(:payment, subscription: Fabricate(:subscription))
    end
    it "should setup the code attribute using a `PAYMENT` suffix" do
      expect(@payment.code).to eq("#{Time.now.to_i}PAYMENT")
    end

  end

end
