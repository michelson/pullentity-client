require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Creating of a view file" do
  before(:all) do
    ::Pullentity::Client::Generate::Project.create('dailyfocus')
  end

  context "Creating a view file and its spec" do
    before(:each) do
      system("cd dailyfocus && bundle exec pullentity view g view user")
    end

    it "should have created the view within the source/views directory" do
      pending
      File.exists?("dailyfocus/source/views/_user.haml").should be_true
      File.exists?("dailyfocus/spec/views/user_spec.coffee").should be_true
    end

  end


  after(:all) do
    #remove_directories('dailyfocus', 'app', 'spec/views')
  end

end