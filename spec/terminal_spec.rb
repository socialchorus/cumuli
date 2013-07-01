require 'spec_helper'

describe Strawboss::Terminal do
  it "clears environmental variables" do
    preserving_env do
      ENV['GEM_HOME'] = 'somewhere-over-the-rainbow'

      terminal = Strawboss::Terminal.new('$GEM_HOME')
      terminal.clear_env

      ENV['GEM_HOME'].should == nil
    end
  end

  xit "spawns a new thread that runs the command" do
    preserving_env do
      pid = fork do
        Strawboss::Terminal.new('STRAWBOSSED=true').spawn
      end
      Process.kill('INT', pid)
      ENV['STRAWBOSSED'].should == true
    end
  end
end
