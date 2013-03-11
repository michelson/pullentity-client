require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "PullentityClient Generator Commands" do
  context "Help command:" do
    context "PullentityClient help" do
      it "should display the basic help for the CLI" do
        response, status = capture_with_status(:stdout){ Pullentity::Client::CLI.start(['help']) }
        status.should eql(Pullentity::Client::CLI::STATUS_TYPES[:success])
      end
    end
    context "PullentityClient help invalid_task" do
      it "should display appropriate error message" do
        response, status = capture_with_status(:stderr){ Pullentity::Client::CLI.start(['help', 'blah']) }
        response.should eql("Could not find task \"blah\".\n")
        status.should eql(Pullentity::Client::CLI::STATUS_TYPES[:success])
      end
    end
  end
  context "Info command:" do
    context "PullentityClient info" do
      it "should display the version" do
        response, status = capture_with_status(:stdout){ Pullentity::Client::CLI.start(['info']) }
        #response.should eql("Version #{::Pullentity::Client::VERSION}\n")
        status.should eql(Pullentity::Client::CLI::STATUS_TYPES[:success])
      end
    end
    context "PullentityClient -v (alias)" do
      it "should display the version" do
        response, status = capture_with_status(:stdout){ Pullentity::Client::CLI.start(['-v']) }
        #response.should eql("Version #{::Pullentity::Client::VERSION}\n")
        status.should eql(Pullentity::Client::CLI::STATUS_TYPES[:success])
      end
    end
    context "PullentityClient --version (alias)" do
      it "should display the version" do
        response, status = capture_with_status(:stdout){ Pullentity::Client::CLI.start(['--version']) }
        #response.should eql("Version #{::Pullentity::Client::VERSION}\n")
        status.should eql(Pullentity::Client::CLI::STATUS_TYPES[:success])
      end
    end
  end
  context "New command: " do
    context "Help (PullentityClient help new)" do
      it "should display help for the task 'new'" do
        response, status = capture_with_status(:stdout){ Pullentity::Client::CLI.start((["project", "help", "new"])) }
        status.should eql(Pullentity::Client::CLI::STATUS_TYPES[:success])
      end
    end
    context "Generate a new project: " do
      context "with no name (PullentityClient new)" do
        it "should exit with error" do
          response, status = capture_with_status(:stderr){ Pullentity::Client::CLI.start(['project', 'new']) }
          #puts response
          #response.include?("new was called incorrectly. Call as").should be_true
          #response.should eql("\"new\" was called incorrectly. Call as \"rspec new <name> <id> <platform>\".\n")
        end
      end
      context "with custom name (PullentityClient new Demo)" do
        it "should generate new project \"Demo\"" do
          response, status = capture_with_status(:stdout){ Pullentity::Client::CLI.start(['project', 'new', 'Demo']) }

          status.should eql(Pullentity::Client::CLI::STATUS_TYPES[:success])
        end
        after (:all) do
          remove_directories("Demo")
        end
      end
      context "with custom name and id (ti new Demo com.mycompany.demo)" do
        it "should generate new project \"Demo\" with id \"com.mycompany.demo\"" do
          response, status = capture_with_status(:stdout){ Pullentity::Client::CLI.start(['project', 'new', 'Demo', 'com.mycompany.demo']) }

		  status.should eql(Pullentity::Client::CLI::STATUS_TYPES[:success])
        end
        after (:all) do
          remove_directories("Demo")
        end
      end
      context "with custom name, id and platform (PullentityClient new Demo com.mycompany.demo ipad)" do
        it "should generate new project \"Demo\" with id \"com.mycompany.demo\" and for platform \"ipad\"" do
          response, status = capture_with_status(:stdout){ Pullentity::Client::CLI.start(['project', 'new', 'Demo', 'com.mycompany.demo']) }

		      status.should eql(Pullentity::Client::CLI::STATUS_TYPES[:success])
        end
        after (:all) do
          remove_directories("Demo")
        end
      end
    end
  end
end
