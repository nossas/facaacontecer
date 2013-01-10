# coding: utf-8
describe Order do

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

      it { should_not allow_mass_assignment_of :uuid }

      it "generates UUID before validation on_create" do
        @order = Order.new
        @order.valid?
        @order.uuid.should_not be_nil
      end
    end
end
