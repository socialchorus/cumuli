Given(/^the app suite is loaded$/) do
  @app = Cumuli::Spawner::App.new({
    env: 'test',
    wait_time: 5,
    log_dir: File.dirname(__FILE__) + "/../../spec/fixtures/log",
    app_dir: File.dirname(__FILE__) + "/../../spec/fixtures/app_set"
  })
  @app.start
  @app.wait_for_apps
  @pid = @app.pid
end

Given(/^the current thread is listening for signals$/) do
  @signals = []

  ['KILL', 'INT', 'TERM', 'HUP'].each do |signal|
    trap signal do
      @signals << signal
    end
  end
end

When(/^I shutdown the app suite$/) do
  step "the current thread is listening for signals"
  @app.stop
end

When(/^the forked pid receives an (.*) signal$/) do |signal|
  step "the current thread is listening for signals"
  Process.kill(signal, @pid)
end

Then(/^I should see that the rake was not aborted$/) do
  @signals.should be_empty
end

Then(/^the processes should not be running$/) do
  Cumuli::Waiter.new.wait_until(3) do
    report = Cumuli::PS.new.report(@pid)
    report.empty?
  end
end

