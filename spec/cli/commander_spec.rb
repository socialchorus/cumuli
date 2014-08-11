require 'spec_helper'

describe Cumuli::CLI::Commander do
  describe "#build" do
    let(:command) { 'foreman start -p 3030' }
    let(:commander) { Cumuli::CLI::Commander.new(command) }

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

    it "concludes with the command" do
      commander.build.should match(/#{command}$/)
    end

    describe "reading from the file system" do
      it "prefaces with the right rvm information" do
        Dir.chdir(File.dirname(__FILE__) + "/../fixtures/app_set/loopy") do
          commander.build.should include('2.0.0-p451')
        end
      end
    end
  end
end
