require 'spec_helper'

describe SubscriptionsController do


  describe "POST #create" do
    let(:subscriber)  { User.make! }
    let(:project)     { Project.make! }
    let(:options)      { { code: 'random', value: 10.00 } }

    it "should create and send an email to the subscriber" do
      post :create, subscriber_id: subscriber.id, project_id: project.id, subscription: options
      
      expect(response.status).to eq(302)
      expect(ActionMailer::Base.deliveries.last.to).to eq([subscriber.email])
    end


  end

end
