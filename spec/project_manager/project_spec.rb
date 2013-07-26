require 'spec_helper'

describe Cumuli::ProjectManager::Project do
  let(:type) { 'app' }
  let(:port) { 3000 }
  let(:wait_time) { 0.1 }
  let(:app) {
    Cumuli::ProjectManager::Project.new('activator', {
      'repository' => 'git@github.com:socialchorus/activator.git',
      'database_config' => 'config/database.config',
      'database_sample_config' => 'config/database.example.config',
      'type' => type,
      'port' => port,
      'wait_time' => wait_time,
      'setup_scripts' => ['bundle', 'rake db:create:all', 'rake db:migrate']
    })
  }

  it "stores configuration data" do
    app.name.should == 'activator'
    app.path.should == './activator'
    app.repository.should == 'git@github.com:socialchorus/activator.git'
    app.type.should == 'app'
    app.port.should == 3000
    app.wait_time.should == 0.1
  end

  describe '#wait?' do
    context "when the type is 'app'" do
      context "when there is no port" do
        let(:port) { nil }

        it "should be false" do
          app.wait?.should be_false
        end
      end

      context "when there is a port" do
        it "should be true" do
          app.wait?.should be_true
        end
      end
    end

    context "when the type is something else" do
      let(:type) { 'service' }

      it "is false" do
        app.wait?.should be_false
      end
    end
  end

  describe '#to_procfile' do
    context "when an app" do
      it "returns a line with a port number" do
        app.to_procfile.should == "activator: cumuli ./activator -p 3000\n"
      end
    end

    context "when a service" do
      let(:type) { 'service' }

      it "returns a line without a port" do
        app.to_procfile.should == "activator: cumuli ./activator\n"
      end
    end

    context "when something else" do
      let(:type) { 'helper' }

      it "returns an empty string" do
        app.to_procfile.should == ""
      end
    end
  end

  describe 'waiting' do
    describe '#wait_for_start' do
      it "raises an error if the app in unavailable via TCP socket after timeout" do
        TCPSocket.should_receive(:new).with('127.0.0.1', 3000).and_raise(Exception)
        expect {
          app.wait_for_start
        }.to raise_error
      end

      it "does not raise an error if the TCP socket is available" do
        TCPSocket.should_receive(:new).with('127.0.0.1', 3000)
        expect {
          app.wait_for_start
        }.not_to raise_error
      end
    end
  end
end
