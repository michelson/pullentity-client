require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Creating of a view file" do
  before(:all) do
    ::Pullentity::Client::Generate::Project.create('dailyfocus')
  end

  context "Creating a view file and its spec" do
    before(:each) do
      system("cd dailyfocus && pullentity build mm")
    end

    it "should have created the build directory" do
      File.directory?("dailyfocus/build").should be_true
    end

  end

  after(:all) do
    #remove_directories('dailyfocus', 'app', 'spec/views')
  end
end