require 'spec_helper'


describe SubscriptionWorker do
  
  describe "#perform" do
    
    before do 
      Fabricate(:subscription)
      Sidekiq::Testing.fake!
    end

    it { expect(SubscriptionWorker.jobs.size).to eq(1) }

  end
end
