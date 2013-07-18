Given(/^the app suite is loaded$/) do
  @app = Cumuli::App.new({
    env: 'test',
    wait_time: 5,
    log_dir: File.dirname(__FILE__) + "/../../spec/fixtures/log",
    app_dir: File.dirname(__FILE__) + "/../../spec/fixtures/app_set"
  })
  @app.start
  @pid = @app.pid
end

When(/^I shutdown the app suite$/) do
  @trapped = false

  trap('INT') do
    @trapped = true
  end

  @app.stop
end

Then(/^I should see that the rake was not aborted$/) do
  @trapped.should == false
end

Then(/^the processes should not be running$/) do
  Cumuli::Waiter.new.wait_until(3) do
    pses = Cumuli::PS.new.children(@pid)
    pses.nil?
  end
end

