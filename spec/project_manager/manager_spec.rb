require 'spec_helper'

describe Cumuli::ProjectManager::Manager do
  let(:app_path) { File.dirname(__FILE__) + "/../fixtures/project_manager" }
  let(:loader) { 
    Cumuli::ProjectManager::Manager.new(app_path)
  }
  let(:procfile_path) { "#{app_path}/Procfile" }
  let(:procfile_contents) { File.read(procfile_path) }

  describe "#publish" do
    before do
      File.delete(procfile_path) if File.exist?(procfile_path)
    end

    it "write a procfile with a line for every service or app" do
      loader.publish
      procfile_contents.lines.size.should == 5
    end
  end

  describe "#projects" do
    it "is a collection of project objects, one for each entry in the yml" do
      loader.projects.size.should == 7
      loader.projects.map{|a| a.class }.uniq.should == [Cumuli::ProjectManager::Project]
    end
  end
end
