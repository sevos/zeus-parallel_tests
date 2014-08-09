Given(/^everything is setup$/) do
  @everything = true
end

Then(/^everything works$/) do
  expect(@everything).to be_truthy
end
