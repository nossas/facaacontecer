Given(/^I choose "(.*?)" for "(.*?)"$/) do |arg1, arg2|
  choose arg1 
end


Given(/^I select "(.*?)" for "(.*?)"$/) do |arg1, arg2|
  select arg1, from: arg2 
end


Given(/^I choose an "(.*?)" subscription of "(.*?)"$/) do |arg1, label|
  interval = case arg1
      when 'annual'   then 'Anual'
      when 'monthly'  then 'Mensal'
      when 'biannual' then 'Semestral'
    end
  choose interval 
  within(".#{arg1}")  do
    choose label
  end
end
