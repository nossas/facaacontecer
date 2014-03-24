Given(/^I choose "(.*?)" for "(.*?)"$/) do |arg1, arg2|
  choose arg1 
end


Given(/^I select "(.*?)" for "(.*?)"$/) do |arg1, arg2|
  select arg1, from: arg2 
end


Given(/^I choose a "(.*?)" subscription of "(.*?)"$/) do |arg1, value|
  interval = case arg1
             when 'monthly' then 'Mensal'
             when 'biannual' then 'Semestral'
             when 'annual' then 'Anual'
             end
  choose(interval)

  within(".#{arg1}")  do
    choose value
  end
end


Then(/^the subscription status should be (.*?)$/) do |arg1|
  if Subscription.last
    expect(Subscription.last.state.to_s).to eq(arg1)
  end
end



######## AFTER SUBSCRITPION #######
#
Given(/^I subscribe using (.*?)$/) do |payment|

  if payment == 'boleto'
    steps %Q{
      And I fill in Nome with "Luiz"
      And I fill in Sobrenome with "Fonseca"
      And I fill in CPF with "919.133.769-07"
      And I fill in Data de nascimento with "13/11/1980"
      And I fill in Email with "email@email.com"
      And I fill in Telefone with "(55) 21122-2123"
      And I choose "R$ 90" for "Qual o valor?"
      And I choose "Boleto" for "Qual a forma de pagamento?"
      And I select "Semestral" for "Frequência de pagamento"
      And I fill in CEP with "22220-000"
      And I fill in Endereço with "Rua qexmeplo 12"
      And I fill in Número with "450"
      And I fill in Complemento with "Apt 601"
      And I fill in Bairro with "Larnjas"
      And I fill in Cidade with "Recife"
      And I select "CE" for "Estado"
      And I click on Contribuir!
    }
  end

  
end


When(/^I reload the subscription page$/) do
  SubscriptionWorker.drain # Executing all queued jobs
  visit current_path
end



Then(/^I should see the subscription boleto url$/) do
  if sub = Subscription.last
    page.should have_content(sub.payments.last.url)
  else
    raise "Couldn't find subscription".white.on_red
  end

end


