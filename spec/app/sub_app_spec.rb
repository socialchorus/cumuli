require 'spec_helper'

describe Cumuli::App::SubApp do
  let(:sub_app) {
    Cumuli::App::SubApp.new(
      "nodified: ../../../bin/cumuli ./noded -p 2323"
    )
  }

  describe '#wait_for_start' do
    it "raises an error if the app in unavailable via TCP socket after timeout" do
      TCPSocket.should_receive(:new).with('localhost', 2323).and_raise(Exception)
      expect {
        sub_app.wait_for_start(0.002)
      }.to raise_error
    end

    it "does not raise an error if the TCP socket is available" do
      TCPSocket.should_receive(:new).with('localhost', 2323)
      expect {
        sub_app.wait_for_start(10)
      }.not_to raise_error
    end
  end
end
