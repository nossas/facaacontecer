require 'spec_helper'

describe UsersController do

  describe "#create" do

    before do
      @user = Fabricate(:user, email: 'test@email.com', first_name: "Joao") 
      @project = Fabricate(:project)
    end

    let(:http_params) do
      { user: { 
          first_name:         "Zé",
          last_name:          "Da Silva" ,
          birthday:           "1988/11/12", 
          email:               "test@email.com",
          cpf:                CPF.generate.to_s,
          address_street:     "Rua Belisario Tavora 500",
          address_extra:      "Laranjeiras",
          address_number:     "100",
          address_district:   "Laranjeiras",
          city:               "Rio de Janeiro",
          state:              "RJ",
          country:            "BRA",
          postal_code:            "78132-500",
          phone:              "(21) 997137471",

          subscriptions_attributes: [
            {
              value: "30.0",
              plan: "monthly",
              payment_option: 'creditcard',
              project_id: @project.id.to_s,
              bank: ""
            }
          ]
        }
    }

    end



    context "When a existing user is sending its subscriber data" do
      before do
        post :create, http_params
      end

      it "should update the user data when receiving a new one" do
        expect(@user.reload.first_name).to eq('Zé')
      end

      it "should redirect_to the last subscription created" do
        expect(response).to redirect_to action: :show, controller: :subscriptions, id: @user.subscriptions.last.id 
      end

      it  "should not generate duplicated records for subscription" do
        expect(Subscription.count).to eq(1)
      end
    end


    context "When a NEW user is sending its subscriber data" do
      before do
        http_params[:user][:email] = 'test_new@gmail.com'
        post :create, http_params
      end

      it "should not update anything" do
        expect(@user.reload.first_name).to eq('Joao')
      end

      it "should have now 2 users (the new one, the existing one)" do
        expect(User.count).to eq(2)
      end

      it "should redirect_to the last subscription created" do
        expect(response).to redirect_to action: :show, controller: :subscriptions, id: User.last.subscriptions.last.id 
      end

    end

  end
end
