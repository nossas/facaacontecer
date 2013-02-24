# coding: utf-8
describe Subscription do

  context "association" do
    it { should belong_to :project }
    it { should belong_to :subscriber }
  end

  context "validations" do
    [
      :value, :project, :subscriber, :code
    ].each do |attribute|
      it { should validate_presence_of attribute }
    end
  end


  context "attributes" do
    [
      :code, :value
    ].each do |property|
      it { should allow_mass_assignment_of property }
    end

  end
end
