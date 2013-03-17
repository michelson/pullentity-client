require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Creating of a new Pullentity Client Project" do

  before(:all) do
    ::Pullentity::Client::Generate::Project.create('dailyfocus')
  end

  context "Directories should be created" do
    before :all
      system("cd dailyfocus && bundle exec pullentity view g view user")
    end



  end



  after(:all) do
    remove_directories('dailyfocus')
  end
end