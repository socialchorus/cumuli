require 'spec_helper'

describe Cumuli::App::Procs do
  let(:procs) { Cumuli::App::Procs.new(app_set_dir) }

  it "#names includes all the app names listed in the Procfile" do
    procs.names.should =~ [
      'loopy', 'nodified'
    ]
  end

  describe '#map' do
    it "maps names to ports" do
      procs.map['nodified'].should == 2323
    end

    it "return a nil port when the app has no port" do
      procs.map['loopy'].should == nil
    end 
  end
end
