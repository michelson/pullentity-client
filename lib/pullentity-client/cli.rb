require "thor/group"

module Pullentity
  module Client
    class CLI < Thor
      include Utils
      include Thor::Actions

      STATUS_TYPES = {:success          => 0,
                      :general_error    => 1,
                      :not_supported    => 3,
                      :not_found        => 4,
                      :incorrect_usage  => 64,
                      }

      no_tasks {
        def cli_error(message, exit_status=nil)
          $stderr.puts message
          exit_status = STATUS_TYPES[exit_status] if exit_status.is_a?(Symbol)
          exit(exit_status || 1)
        end
      }

      ### TODO: When these commands list grows big, we need to move them into a seperate commands.rb file
      map %w(--version -v) => 'info'
      desc "info", "information about Pullentity::Client::Generator."
      def info
        say "Version #{::Pullentity::Client::VERSION}"
      end

      map %w(r) => 'server'
      desc "server ", "run middleman app"
      def server
        system "echo == :::pullentity-client STARTING::: =="
        system "bundle exec middleman server"
      end

      map %w(r) => 'server'
      desc "login ", "retreives token"
      long_desc "pullentity-client login user pass"
      def login(email)
        begin
          hsh = YAML.load_file(location + "pullentity.yml")
        rescue => e
          say "and pullentity.yml file is created", :red
          raise e
        end
        say("In order to retreive your authentication token we need your pullentity password")
        password = ask("password: ")
        uri = URI.parse("http://pullentity.dev:3000/api/v1/login.json")
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.request_uri)
        request.set_form_data({"email" => email, "password" => password  })
        response = http.request(request)
        if response.status == 200
          say "Your token is:"
          say response.body , :green
          hsh["auth_token"] = response.body
          File.open("dailyfocus/pullentity.yml", "w"){|f| YAML.dump(hsh, f)}
        else
          say response.body, :red
        end
      end

      map %w(b) => 'build'
      desc "build ", "builds middleman/ios/android app"
      long_desc "Build pullentity-client static files (middleman), See 'pullentity-client help build' for more information.
                \n\nExample:
                \n\npullentity-client build mm ==> build middleman static files."

      #method_option :attributes, :type => :hash, :default => {}, :required => true
      #method_options :type => "all"
      #method_options :ver => "5.1"
      def build(type="", ver="5.1")
        puts "echo ::== pullentity-client BUILD =="
        ::Pullentity::Client::Builder::Middleman.build
      end

      register Pullentity::Client::Generate::Project, :project, "project", "project generator"
      register Pullentity::Client::Generate::Exporter, :export, "export", "export theme"

    end
  end
end
