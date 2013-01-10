#coding: utf-8
require 'spec_helper'

describe OrdersController do
  describe "#new" do
    before do
      @project = Project.make!
    end
    it "should return a new form for orders when a project_id is present" do
      get :new, project_id: @project.id
      response.should be_success
    end
  end


  describe "#create" do
    before :each do 
      MyMoip.logger = Rails.logger
      @project = Project.make!
      @order = {
        name: "Luiz Fonseca",
        email: "juquinha@net.br",
        address_one: "Rua Zero Zero",
        address_two: "Prox. A padaria X",
        address_number: "450",
        address_neighbourhood: "Laranjeiras",
        city: "Rio de Janeiro",
        state: "RJ",
        country: "BRA",
        value: 50.0,
        birthday: "12/11/1988",
        cpf: "017.011.011-45",
        phone: "(21) 99999991",
        zip: "78132-500"
      }
      @param = stub_model(Order, random_attributes: true, save: true)
    end
    context "Invalid response" do 
      before do
        @order[:city] = nil
        post :create, project_id: @project.id, order: @order, format: :json
      end
      it "should return invalid response if order wasn't OK" do
        response.status.should == 202
      end


      it "should return a json with errors if the response is invalid" do
        parsed_response = JSON.parse(response.body)['order']
        parsed_response.should include("city")
        parsed_response.should_not include("email")
      end

    end
 
    context "Valid response" do
      before do
        Order.stub(:create!).with(@order).and_return(@param)
        post :create, project_id: @project.id, order: @order, format: :json
      end

      it "should return valid response if order was OK" do
        response.status.should == 200
      end

      it "should return token if the order validation was OK and instruction was successful" do
        Order.any_instance.stub(:token).and_return("token")
        JSON.parse(response.body)['order']['token'].should == "token"     
      end


      it "should return nil if the order validation was OK but instruction was unsuccessful" do
        Order.any_instance.stub(:token).and_return(nil)
        JSON.parse(response.body)['order']['token'].should == nil 
      end
    end
      
  end
end
