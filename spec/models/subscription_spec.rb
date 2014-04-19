# coding: utf-8
describe Subscription do

  context "association" do
    it { should belong_to :project }
    it { should belong_to :user }
    it { should have_many :payments }
  end

  context "validations" do
    before { Fabricate(:subscription) }
    it { should validate_presence_of :value }
    it { should validate_presence_of :project }
    it { should validate_presence_of :user }
    it { should validate_presence_of :payment_option }
    it { should validate_uniqueness_of :code }
  end

  context "Field validations" do
    it "should require the bank attribute if the subscription is DEBIT" do
      expect(Subscription.new(payment_option: 'debit')).to have(1).error_on(:bank)
    end

    it "should not require the bank attribute if the subscription is CREDITCARD" do
      expect(Subscription.new(payment_option: 'creditcard')).to have(0).error_on(:bank)
    end

    it "should not require the bank attribute if the subscription is BOLETO" do
      expect(Subscription.new(payment_option: 'slip')).to have(0).error_on(:bank)
    end


    it "should only allow the permitted bank names 'banco_do_brasil', 'itau' and 'bradesco'" do
      expect(Subscription.new(payment_option: 'debit', bank: 'anything')).to have(1).error_on(:bank)
      expect(Subscription.new(payment_option: 'debit', bank: 'itau')).to have(0).error_on(:bank)
    end

  end


#  context "#worker" do

    #before { @subscription = Fabricate(:subscription, payment_option: 'slip') }

    #it "should have called SubscriptionWorker after_create event" do
      #expect(SubscriptionWorker.jobs.size).to eq(1)
    #end

  #end


  context "#generate_unique_code" do
    subscription = Fabricate(:subscription)

    it "should generate an unique code based on current time/stamp" do
      expect(subscription.code.split("_")[1].to_i).to be_within(30.seconds.to_i).of(Time.now.to_i)
    end

  end


  context "#debito" do
    before { @subscription = Fabricate(:subscription, payment_option: "debit", value: 90, bank: 'itau') }

    it "should return false if the payment_option isn't debit" do
      @subscription.payment_option = 'slip'
      expect(@subscription.debito).to eq(false)
    end

    context "#available" do
      it "should show all available banks" do
        expect(@subscription.debito.available).to eq([:banco_do_brasil, :bradesco, :banrisul, :itau])
      end
    end


    context "#payment_request", vcr: true do

      it "should return a Payment Request instance when a bank is set up" do
        expect(@subscription.debito.payment_request).to be_a_kind_of(MyMoip::PaymentRequest)
      end

      it "should return success if the payment request is valid" do
        expect(@subscription.debito.success?).to eq(true)
      end


      it "should return a bank debit url if the payment request was successful" do
        expect(@subscription.debito.url).to eq("https://desenvolvedor.moip.com.br/sandbox/Instrucao.do?token=M2S0U1W4R043J198L2C0E0U1R5O3Q0O2R2N020U0V0D0E0N4V5O3X481P063")
      end


      it "should save the token in the payment token's column" do
        expect(@subscription.debito.token).to eq("B2L0Q1C4J0A4M128O1X9B350F5M6V6C6F5P0Y0705030F0K4Z5S8O0Y7N1E6")
      end
    end

  end



  context "#boleto", vcr: true do
    before { @subscription = Fabricate(:subscription, payment_option: "slip", value: 320) }

    it "should return false if the payment_option isn't SLIP (boleto)" do
      @subscription.payment_option = 'debit'
      expect(@subscription.boleto).to eq(false)
    end


    context "#payment_request" do
      it "should return an instance of MyMoip" do
        expect(@subscription.boleto.payment_request).to be_a_kind_of(MyMoip::PaymentRequest)
      end
    end


    context "#success?" do
      it "should return true if the payment request was successful" do
        expect(@subscription.boleto.success?).to eq(true)
      end
    end

    context "#url" do
      it "should return a valid BOLETO url when the requests finishes" do
        expect(@subscription.boleto.url).to eq("https://desenvolvedor.moip.com.br/sandbox/Instrucao.do?token=R2N081R4F0E3Z1Z8R2S0B1U3J2P9S3Z4Z1Q0N050O0G0Z0C4H503N4U144T4")
      end
    end

    context "#token" do
      it "should return a valid token in order to consult it afterwards" do
        expect(@subscription.boleto.token).to eq("D2T081O4P0J4T1A811Q9B3O2M0C4A3Q3X260L0Y0L0H0I0T475T830N7B1O7")
      end
    end
  end
end
