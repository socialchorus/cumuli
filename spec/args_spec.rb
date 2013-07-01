require 'spec_helper'

describe Strawboss::Args do
  let(:argv) { ["../mactivator", "-p", "4000"] }
  let(:args) { Strawboss::Args.new(argv) }
  
  it "#dir will return the first element passed in" do
    args.dir.should == "../mactivator"
  end
  
  it "#name is correctly determined from the directory" do
    args.name.should == 'mactivator'
  end
  
  it "#foreman_options should be a string representation of the rest of the arguments" do
    args.foreman_options.should == '-p 4000'
  end
end