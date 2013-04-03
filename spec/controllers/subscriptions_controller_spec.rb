require 'spec_helper'

describe SubscriptionsController, worker: true do
  

  describe "POST #create" do
    let(:subscriber)  { User.make!(cpf: CPF.generate) }
    let(:project)     { Project.make! }
    let(:options)     { { code: 'random', value: 10.00 } }

    context "Without an inviter" do
      before do
        post :create, subscriber_id: subscriber.id, project_id: project.id, subscription: options
      end

      it "should be successful" do
        expect(response.status).to eq(302)
      end


      it "should redirect to the thank_you_path of the subscriber" do
        expect(response).to redirect_to(thank_you_path(subscriber))
      end
    end
  end

end
