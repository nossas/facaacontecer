require 'spec_helper'

describe SubscriptionsController, worker: true do


  #describe "POST #create" do
    #let(:subscriber)  { User.make! }
    #let(:project)     { Project.make! }
    #let(:options)     { { code: 'random', value: 10.00 } }

    #context "Without an inviter" do
      #before do
        #post :create, subscriber_id: subscriber.id, project_id: project.id, subscription: options
      #end

      #it "should be successful" do
        #expect(response.status).to eq(302)
      #end

      #it "should send an email to the subscriber" do
        #expect(ActionMailer::Base.deliveries.last.to).to eq([subscriber.email])
      #end

      #it "should redirect to the thank_you_path of the subscriber" do
        #expect(response).to redirect_to(thank_you_path(subscriber))
      #end
    #end


    #context "With an inviter" do
      #let(:invitee) { User.make!(email: 'invitee@invitee.com') }
      #let(:host)    { User.make!(email: 'host@host.com') }
      #before do
        #invitee.invite.update_attribute(:parent_user_id, host.id)
        #post :create, subscriber_id: invitee.id, project_id: project.id, subscription: options
      #end

      #it "should be successful" do
        #expect(response.status).to eq(302)
      #end

      #it "should send an email to the subscriber" do
        #expect(ActionMailer::Base.deliveries.map(&:to)).to include([invitee.invite.host.email])
      #end

      #it "should send an email to the inviter" do
        #expect(ActionMailer::Base.deliveries.map(&:to)).to include([invitee.email])
      #end

      #it "should redirect to the thank_you_path of the subscriber" do
        #expect(response).to redirect_to(thank_you_path(invitee))
      #end 

    #end



  #end

end
