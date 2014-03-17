Given(/^I choose "(.*?)" for "(.*?)"$/) do |arg1, arg2|
  choose arg1 
end


Given(/^I select "(.*?)" for "(.*?)"$/) do |arg1, arg2|
  select arg1, from: arg2 
end


Given(/^I choose a "(.*?)" subscription of "(.*?)"$/) do |arg1, value|

  find('.subscription-plan', text: 'Frequência de pagamento').choose(arg1)

  within(".#{arg1}")  do
    choose value
  end
end


Then(/^the subscription status should be active$/) do
  if Subscription.last
    expect(Subscription.last.state).to eq('waiting')
  end
end
