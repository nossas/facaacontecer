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
