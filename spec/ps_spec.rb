require 'spec_helper'

describe Cumuli::PS do
  let(:ps_data) { File.read(File.dirname(__FILE__) + "/fixtures/ps.txt") }
  let(:ps) { Cumuli::PS.new(ps_data) }
  let(:pid) { 28280 }

  describe '#root' do
    it "should find the lead foreman process" do
      ps.root_pid.should == pid
    end
  end

  describe '#family' do
    let(:family) { ps.family(pid) }
    let(:children) { ps.children(pid) }

    it "should not include the passed in pid" do
      family.should_not include(pid)
    end

    it "includes direct children" do
      family.should include(*children)
    end

    it "includes grandchildren" do
      children.each do |child|
        family.should include(*ps.children(child))
      end
    end
  end

  describe '#report' do
    it "prints all the lines descended from the root process" do
      ps.report.should == report_text
    end
  end
end
