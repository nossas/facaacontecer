require 'spec_helper'

describe SubscribersController do
  shared_examples "subscriber response" do
    it "should be successful" do
      expect(response).to be_success 
    end

    it "should return a json document with his subscription url" do
      expect(JSON.parse(response.body)).to include("subscription_url")
    end
  end

  describe "POST #create" do
    let(:user)    { User.make! }
    let(:project) { Project.make! }
    let(:options) do
      {
        name:             "Juquinha da silva",
        birthday:         "1988/11/12",
        email:            "juquinha@zip.net",
        cpf:              "11144477735",
        address_street:   "Rua Belisario Tavora 500",
        address_extra:    "Laranjeiras",
        address_number:   "100",
        address_district: "Laranjeiras",
        city:             "Rio de Janeiro",
        state:            "RJ",
        country:          "BRA",
        zipcode:          "78132-500",
        phone:            "(21) 97137471"
      }
    end



    context "When THERE IS NO invite code" do
      before do
        post :create, project_id: project.id, user: options, format: :json 
      end

      it_behaves_like "subscriber response"
    end

    context "When THERE IS a invite code" do
      before do
        session[:invite] = user.invite.code
        post :create, project_id: project.id, user: options, format: :json 
      end

      it_behaves_like "subscriber response"
    end
  end

end
