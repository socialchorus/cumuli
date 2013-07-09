require 'spec_helper'

describe Cumuli::Waiter do
  let(:timeout) { 0.1 }

  context "default message" do
    let(:waiter) { Cumuli::Waiter.new }

    it "will raise a default message if the block never resolves to a non-falsey value" do
      expect {
        waiter.wait_until(timeout){ false }
      }.to raise_error(Cumuli::Waiter::MESSAGE)
    end

    it "will return the truthy value that it gets from the block" do
      waiter.wait_until{ 'truthy' }.should == 'truthy'
    end
  end

  context "initialization with a message" do
    let(:message) { "Something went unexpected" }
    let(:waiter) { Cumuli::Waiter.new(message) }

    it "raises the message if the block does not resolve" do
      expect {
        waiter.wait_until(timeout){ false }
      }.to raise_error(message)
    end
  end

  context "intitialization with an exception" do
    let(:exception) { RuntimeError.new("Something went unexpected") }
    let(:waiter) { Cumuli::Waiter.new(exception) }

    it "raises the message if the block does not resolve" do
      # Rspec is having issues with the normal expect block ...
      # so let's do this the long way
      raised = false
      begin
        waiter.wait_until(timeout){ false }
      rescue Exception => e
        raised = true
        e.should == exception
      end
      raised.should == true
    end
  end
end
