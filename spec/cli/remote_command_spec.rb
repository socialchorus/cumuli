require 'spec_helper'

describe Cumuli::CLI::RemoteCommand do
  let(:argv) { ["cumuli:remote[rake db:migrate]", "DIR=./mactivator"] }
  let(:remote_command) { Cumuli::CLI::RemoteCommand.new(argv) }

  it "parses the directory from the arguments" do
    remote_command.dir.should == "./mactivator"
  end

  it "constructs a command using the Commander" do
    commander = double(build: 'yup')
    Cumuli::CLI::Commander.should_receive(:new)
      .with("rake db:migrate")
      .and_return(commander)
    remote_command.command.should == 'yup'
  end
end
