require 'spec_helper'

describe Strawboss::Assassin do
  let(:pid) { 345 }
  let(:first_gen_pids) { [33141, 17925] }
  let(:second_gen_pids) { [45228, 45229] }
  let(:assassin) { Strawboss::Assassin.new(pid, 'TERM') }
  let(:ps_shell_mock) { File.new(File.dirname(__FILE__) + "/support/ps_output.txt") }

  before do
    assassin.stub(:ps_shell).and_return(ps_shell_mock)
  end

  describe '#pids, finding via recursion' do
    it "includes the one send on initialization" do
      assassin.pids.should include(pid)
    end

    it "includes first generation pids" do
      assassin.pids.should include(*first_gen_pids)
    end

    it "finds second generation pids" do
      assassin.pids.should include(*second_gen_pids)
    end
  end

  describe '#kill' do
    it "tell Process to kill off the pids" do
      assassin.stub(:pids).and_return(first_gen_pids)
      Process.should_receive(:kill).exactly(:twice) do |signal, pid|
        signal.should == 'TERM'
        first_gen_pids.should include(pid)
      end
      assassin.kill
    end
  end
end

