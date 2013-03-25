require 'spec_helper'

describe SubscriptionsController do


  describe "POST #create" do
    let(:subscriber)  { User.make! }
    let(:project)     { Project.make! }
    let(:options)     { { code: 'random', value: 10.00 } }
    let(:queue)       { SuckerPunch::Queue.new(:mail) }

    before do
      queue.register(MailWorker, 2)
      post :create, subscriber_id: subscriber.id, project_id: project.id, subscription: options
    end

    it "should be successful" do
      expect(response.status).to eq(302)
    end

    it "should send an email to the subscriber" do
      expect(ActionMailer::Base.deliveries.last.to).to eq([subscriber.email])
    end

    it "should redirect to the thank_you_path of the subscriber" do
      expect(response).to redirect_to(thank_you_path(subscriber))
    end

  end

end
