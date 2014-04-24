Then /^I should see "(.*?)"$/ do |arg1|
  page.should have_content(arg1)
end

Then /^I should not see "(.*?)"$/ do |arg1|
  page.should_not have_content(arg1)
end

When(/^I go to "(.*?)"$/) do |arg1|
  visit to_route(arg1)
end

Then(/^I should be in "(.*?)"$/) do |arg1|
  page.current_path.should be_eql to_route(arg1)
end
