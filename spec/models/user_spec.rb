require 'spec_helper'


describe User do

  context "attributes" do
    [
      :name, :email, :cpf, :birthday, :zipcode,
      :address_street, :address_extra, :address_number,
      :address_district, :city, :state, :phone,  :country
    ].each do |attr|
      it { should allow_mass_assignment_of attr }
      it { should validate_presence_of attr }
      end
  end

  context "associations" do
    it { should have_many :subscriptions } 
    it { should validate_uniqueness_of :email } 
    it { should validate_uniqueness_of :cpf } 
  end


  context "#generate_share_code" do
    it "should create a invite code" do
      user = User.make!
      expect(user.invite.code).to_not eq(nil)
    end
  end

end
