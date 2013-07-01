require 'spec_helper'

describe Strawboss::Commander do
  describe "#build" do
    let(:args) { mock({foreman_options: 'foreman-options-here'}) }
    let(:commander) { Strawboss::Commander.new(args) }

    context "application directory has no .rvmrc" do
      before do
        commander.stub(:rvmrc?).and_return(false)
      end

      it "has not rvm preface" do
        commander.build.should_not include('rvm')
      end
    end

    context "application directory has an .rvmrc" do
      before do
        commander.stub(:rvm_version).and_return('1.9.3')
        commander.stub(:rvmrc?).and_return(true)
      end

      it "has an rvm preface" do
        commander.build.should include('rvm ruby-1.9.3 exec')
      end
    end

    it "ends with a call to foreman" do
      commander.build.should match(/foreman start foreman-options-here$/)
    end

    describe "reading from the file system" do
      it "prefaces with the right rvm information" do
        Dir.chdir(File.dirname(__FILE__) + "/fixtures/app_set/loopy") do
          commander.build.should include('rvm ruby-2.0.0')
        end
      end
    end
  end
end
