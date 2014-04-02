require 'spec_helper'

describe Payment do

  context "associations & validations" do
    it { should validate_presence_of :subscription }
    it { should belong_to :subscription } 
  end



  it "should setup the code attribute using a `PAYMENT` suffix" do
    payment = Fabricate(:payment) 
    expect(payment.code).to eq("#{Time.now.to_i}PAYMENT")
  end

  context "Slip - Boleto" do
    before do 
      @payment = Fabricate(:payment, 
                           subscription: Fabricate(:subscription, payment_option: 'slip'))
      
      Sidekiq::Extensions::DelayedMailer.drain
    end

    it "should send an email with LINK to BOLETO when the subscrition is BOLETO (slip)" do
      expect(ActionMailer::Base.deliveries.last.subject).to eq("[MeuRio] Seu boleto foi gerado!")
      expect(ActionMailer::Base.deliveries.last.to).to eq([@payment.user.email])
    end
  end


  context "Debit - Débito" do
    before do 
      @payment = Fabricate(:payment, 
                           subscription: Fabricate(:subscription, payment_option: 'debit'))
      
      Sidekiq::Extensions::DelayedMailer.drain
    end
    it "should send an email with LINK to BANK when the subscription is DEBITO (debit)" do
      expect(ActionMailer::Base.deliveries.last.subject).to eq("[MeuRio] O link para a sua doação foi gerado!")
      expect(ActionMailer::Base.deliveries.last.to).to eq([@payment.user.email])
    end
  end

  context "Credit Card" do
    it "should NOT send an email not" do

    end
  end



end
