# coding: utf-8
require 'spec_helper'

#describe WebhooksController do
  #before do
    #@subscription = Subscription.make!(code: '123')
    #@webhook = {
      #event: "payment.created",
      #date: "28/12/2012 15:38:46",
      #env: "sandbox",
      #resource: {
        #id: 6, 
        #invoice_id: 13,
        #moip_id: 14456223,
        #subscription_code: "123",
        #amount: 101,
        #status: {
          #code: 2,
          #description: "Iniciado"
        #},
        #payment_method: {
          #code: 1,
          #description: "Cartão de Crédito",
          #credit_card: { 
            #brand: "VISA",
            #holder_name: "Fulano Testador",
            #first_six_digits: "411111",
            #last_four_digits: "1111",
            #vault: "cc7719e7-9543-4380-bdfe-c14d0e3b8ec9"
          #}
        #}
      #}
    #}


    #@update =  {
      #event: "payment.status_updated",
      #date: "28/12/2012 15:38:41",
      #env: "sandbox",
      #resource: {
        #id: 6,
        #status: {
          #code: 6,
          #description: "Em análise"
        #}
      #}
    #} 
  #end


  #describe "POST #subscriptions_status" do
    #context "When the payment status is payment.created" do
      #before do
        #post :subscription_status, @webhook, format: :json
      #end


      #context "When the payment was created" do
        #it "should be successful" do
          #expect(response.status).to eq(200)
        #end



        #it "should create a new instruction with the payment ID" do
          #expect(PaymentInstruction.last.code).to eq "6"
        #end

        #it "should be created with 'started' status" do
          #expect(PaymentInstruction.last.status).to eq 'started'
        #end

      #end
    #end



    #context "When the payment status is payment.updated" do
      #before do
        #@payment = PaymentInstruction.make!(code: '6')
        #post :subscription_status, @update, format: :json
      #end

      #it "should be successful" do
        #expect(response.status).to eq(200)
      #end



      #it "should create a new instruction with the payment ID" do
        #expect(PaymentInstruction.last.code).to eq "6"
      #end

      #it "should be created with 'waiting' status" do
        #expect(PaymentInstruction.last.status).to eq 'waiting'
      #end


    #end

  #end

  ##  describe "GET #bankslip" do

  ##context "When no authorization token is found" do
  ##it "should redirect to root path" do
  ##get :bankslips
  ##expect(response).to redirect_to(root_path)
  ##end
  ##end

  ##context "When a invalid authorization token is found" do
  ##it "should redirect_to root_path" do
  ##ENV['ADMIN_UNIQUE_TOKEN'] = '123'
  ##get :bankslips, token: '1234'
  ##expect(response).to redirect_to(root_path)
  ##end
  ##end


  ##context "When a valid authorization token is found" do
  ##before do 
  ##ENV['ADMIN_UNIQUE_TOKEN'] = '123'
  ##get :bankslips, token: '123'
  ##end

  ##it "should not redirect" do
  ##expect(response).not_to redirect_to(root_path)
  ##end


  ##it "should fetch all Boleto (bank slips) subscriptions" do
  ##Subscription.should_receive(:where).with(payment_option: 'boleto').and_return(ActiveRecord::Relation)
  ##end
  ##end


#end


