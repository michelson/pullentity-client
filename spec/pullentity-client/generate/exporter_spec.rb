require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Creating of a new Pullentity Client Project" do

  before(:all) do
    ::Pullentity::Client::Generate::Project.create('dailyfocus')
  end

  context "Directories should be created" do
    before :all do
      system("cd dailyfocus && bundle exec pullentity export new name")
    end

    it "should generate the export build json" do
      File.exists?("dailyfocus/pullentity_build.json").should be_true
    end

    it "should be a valid json" do
      json  = JSON.parse( IO.read("dailyfocus/pullentity_build.json") )
      #debugger
      json["themes"].size.should == 2
      json["theme_name"].should_not be_empty
      json["layout"].should_not be_empty
      json["list"].should_not be_empty
      json["css"].should_not be_empty
      json["js"].should_not be_empty
      json["head"].should_not be_empty
    end

  end



  after(:all) do
    #remove_directories('dailyfocus')
  end
end