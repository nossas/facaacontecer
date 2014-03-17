# coding: utf-8
describe Subscription do

  context "association" do
    it { should belong_to :project }
    it { should belong_to :subscriber }
    it { should have_many :payment_instructions }
  end

  context "validations" do
    it { should validate_presence_of :value }
    it { should validate_presence_of :project }
    it { should validate_presence_of :subscriber_id }
    it { should validate_presence_of :interval }
    it { should validate_presence_of :payment_option }
  end
  

  context "#generate_unique_code" do
    subscription = Fabricate(:subscription)

    it "should generate an unique code based on current time/stamp" do
      expect(subscription.code).to be_within(1.second.to_i).of(Time.now.to_i)
    end

  end
end
