require 'spec_helper'

describe Cumuli::Spawner::App do
  let(:opts) {
    {
      env: 'test',
      wait: false,
      log_dir: log_dir,
      app_dir: app_set_dir
    }
  }
  let(:app) { Cumuli::Spawner::App.new(opts) }
  let(:logs) { File.readlines("#{log_dir}/test.log") }

  describe '#start' do
    before do
      clear_logs
      app.start
      app.wait_for_apps
    end

    after do
      app.stop
    end

    it "stores a list of subprocesses" do
      app.process_pids.size.should == 9
    end

    it "launches subprocesses with the foreman command" do
      ps_line = Cumuli::PS.new.foremans
      ps_line.size.should == 3
    end

    it "redirects subprocess output to the logs" do
      logs.detect {|line| line.match(/started with pid/) }
    end
  end

  describe '#stop' do
    before do
      app.start
      app.wait_for_apps
    end
  end
end
