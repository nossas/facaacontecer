Given(/^I am in the root path$/) do
  visit root_path
end

Given(/^I fill in (.*?) with "(.*?)"$/) do |arg1, arg2|
  (fill_in arg1, with: arg2).first
end

When(/^I click on (.*?)$/) do |arg1|
  click_on arg1.to_s
end

Given(/^there is a registered user with email: (.*?) and cpf: (.*?)$/) do |arg1, arg2|
  @existing_user = Fabricate(:user, email: arg1, cpf: arg2)
end
