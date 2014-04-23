require 'spec_helper'


describe User do

  context "attributes" do
    [
    :first_name, :last_name, :email, :cpf, :birthday, 
    :postal_code, :address_street, :address_extra, :address_number, 
    :address_district, :city, :state, :phone, :country
    ].each do |attr|
      it { should validate_presence_of attr }
      end
  end

  context "associations" do
    it { should have_many :subscriptions } 
    #it { should validate_uniqueness_of :email }
  end


  context "#generate_share_code" do
    let(:user) { Fabricate(:user) }
    it "should create a invite code" do
      expect(user.invite.code).to_not eq(nil)
    end

    it "should create a invite if the user has an updated account but not yet an invite" do
      user.invite.destroy
      user.update_attribute(:postal_code, '22222050')
      expect(user.invite.code).to_not eq(nil)
    end
  end


  context "Field validations" do

    it "should not accept invalid emails" do
      expect(User.new(email: 'invalid_email#.com')).to have(1).errors_on(:email)
    end


    it "should accept valid emails" do
      expect(User.new(email: 'valid@valid.com')).to have(0).errors_on(:email)
    end

    it "should not accepts users with 15 minus years" do
      expect(User.new(birthday: Date.today - 14.years)).to have(1).errors_on(:birthday)
    end


    it "should accept users with 15 + years" do
      expect(User.new(birthday: Date.today - 16.years)).to have(0).errors_on(:birthday)
    end


    # Length not, format almost there
    it "should not accept phone number with less than 12 characters" do
      expect(User.new(phone: '(21) 9999-999')).to have(1).errors_on(:phone)
    end

    # Length ok, but format is invalid
    it { expect(User.new(phone: '(021) 9999-9999')).to have(1).errors_on(:phone) }

  end

  
  context "#business" do
    before { @user = Fabricate(:user, id: 1, first_name: "TESTER", last_name: "BETA", email: "email@email.com") }


    it "should build an instance of MyMoip::Payer" do
      expect(@user.business.build_payer).to be_a_kind_of(MyMoip::Payer)
    end

    it "should build a json hash called PAYER in order to allow MOIP subscriptions" do
      expect(@user.business.as_payer).to eq({:id=>1, :name=>"TESTER BETA", :email=>"email@email.com", :address_street=>"Rua Belisario Tavora 500", :address_street_number=>"100", :address_street_extra=>"Laranjeiras", :address_neighbourhood=>"Laranjeiras", :address_city=>"Rio de Janeiro", :address_state=>"RJ", :address_country=>"BRA", :address_cep=>"78132500", :address_phone=>"21997137471"})
    end 
  end

  context "#last_donation_date" do
    let(:user) { Fabricate(:user) }
    let(:subscription) { Fabricate(:subscription, user: user) }

    context "when there is no invoices" do
      let(:payment) { Fabricate(:payment, subscription: subscription, state: 'finished') }

      it "gets the last payment date" do
        expect(user.last_donation_date).to eq user.last_successful_payment_date
      end
    end

    context "when there is no payments" do
      let(:invoice) { Fabricate(:invoice, subscription: subscription, status: 'finished') }

      it "gets the last invoice date" do
        expect(user.last_donation_date).to eq user.last_successful_invoice_date
      end
    end

    context "when there is invoices and payments" do
      let(:invoice) { Fabricate(:invoice, subscription: subscription, status: 'finished') }
      let(:payment) { Fabricate(:payment, subscription: subscription, state: 'finished') }

      context "when the last donation is the last invoice" do
        before { invoice.update(created_on_moip_at: 1.week.ago) }
        before { payment.update(paid_at: 2.weeks.ago) }
      
        it "gets the last invoice date" do
          expect(user.last_donation_date).to eq user.last_successful_invoice_date
        end
      end

      context "when the last donation is the last single payment" do
        before { invoice.update(created_on_moip_at: 2.weeks.ago) }
        before { payment.update(paid_at: 1.week.ago) }

        it "gets the last single payment date" do
          expect(user.last_donation_date).to eq user.last_successful_payment_date
        end
      end
    end
  end
end
