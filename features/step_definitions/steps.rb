Then /^I should see "(.*?)"$/ do |arg1|
  page.should have_content(arg1)
end

Then /^I should not see "(.*?)"$/ do |arg1|
  page.should_not have_content(arg1)
end

When(/^I go to "(.*?)"$/) do |arg1|
  visit to_route(arg1)
end

Then(/^I should see the retry button$/) do
  page.should have_css("a.retry-button")
end

Then(/^I should see "(.*?)" element$/) do |arg1|
  page.should have_css(to_element(arg1))
end

When(/^I click in "(.*?)"$/) do |arg1|
  click_link to_link(arg1)
end

Then(/^I should be in "(.*?)"$/) do |arg1|
  page.current_path.should be_eql to_route(arg1)
end

Then(/^I should not be in "(.*?)"$/) do |arg1|
  page.current_path.should_not be_eql to_route(arg1)
end
