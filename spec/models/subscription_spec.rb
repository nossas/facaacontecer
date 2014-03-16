# coding: utf-8
describe Subscription do

  context "association" do
    it { should belong_to :project }
    it { should belong_to :subscriber }
  end

  context "validations" do
    [
      :value, :project, :subscriber_id, :code
    ].each do |attribute|
      it { should validate_presence_of attribute }
    end
  end

end
