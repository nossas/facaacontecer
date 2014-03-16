require 'spec_helper'


describe User do

  context "attributes" do
    [
    :first_name, :last_name, :email, :cpf, :birthday, 
    :zipcode, :address_street, :address_extra, :address_number, 
    :address_district, :city, :state, :phone, :country
    ].each do |attr|
      it { should validate_presence_of attr }
      end
  end

  context "associations" do
    it { should have_many :subscriptions } 
    it { should validate_uniqueness_of :email }
  end


  context "#generate_share_code" do
    it "should create a invite code" do
      user = Fabricate(:user) 
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


    it "should not accept phone number with less than 12 characters" do
      expect(User.new(phone: '(21) 9999-999')).to have(1).errors_on(:phone)
    end

  end



end
