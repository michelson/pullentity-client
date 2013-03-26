require "thor/group"
require "debugger"
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

      map %(n) => 'login'
      desc "auth login <email> ", "login and configures auth_token."
      long_desc "login and configures auth_token"
      def login(email)
        ::Pullentity::Client::Generate::Auth.start(['set_login', email])
      end

      map %(n) => 'sites'
      desc "list sites", "needs auth_token."
      long_desc "list sites, needs auth token , run pullentity login help"
      def sites
        ::Pullentity::Client::Generate::Auth.start(['list_sites'])
      end

      map %(n) => 'select'
      desc "select site", "needs auth_token."
      long_desc "select site, needs auth token , run pullentity login help"
      def select_site
        ::Pullentity::Client::Generate::Auth.start(['select_site'])
      end

      register Pullentity::Client::Generate::Project, :project, "project", "project generator"
      register Pullentity::Client::Generate::Exporter, :export, "export", "export theme"

    end
  end
end
