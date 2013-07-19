require 'spec_helper'

describe Cumuli::App do
  describe '#start' do
    let(:opts) {
      {
        env: 'test',
        wait: false,
        log_dir: log_dir,
        app_dir: app_set_dir
      }
    }
    let(:app) { Cumuli::App.new(opts) }
    let(:logs) { File.readlines("#{log_dir}/test.log") }

    before do
      clear_logs
      app.start
      app.wait_for_apps
    end

    after do
      app.stop
    end

    it "launches subprocesses with the foreman command" do
      ps_line = Cumuli::PS.new.matching.detect{|line| line.match(/foreman: master/) }
      ps_line.should_not be_nil
    end

    it "redirects subprocess output to the logs" do
      logs.detect {|line| line.match(/started with pid/) }
    end
  end
end
