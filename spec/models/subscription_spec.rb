# coding: utf-8
describe Subscription do

  context "association" do
    it { should belong_to :project }
    it { should belong_to :user }
  end

  context "validations" do
    [
      :value, :project, :user
    ].each do |attribute|
      it { should validate_presence_of attribute }
    end
  end


  context "attributes" do
    [
      :value, :token
    ].each do |property|
      it { should allow_mass_assignment_of property }
    end

  end
end
