module Pullentity::Client
  module Generate
    class View < Thor

      include Thor::Actions

      attr_accessor :name, :model

      no_tasks {
        include ::Pullentity::Client::Utils

        def generate_files(view_directory, template)
          spec_template = templates("specs/app_spec.coffee.erb")
          template_destination = "source/#{view_directory}/#{(@context[:domain] || '').downcase}/_#{@name}.haml"
          spec_destination = "spec/#{view_directory}/#{(@context[:domain] || '').downcase}/#{@name}_spec.coffee"
          template( template, template_destination )
          template( spec_template, spec_destination )
        end

        def create(name, context={})
          say "really cool stuff here soon!"
        end

      }

      map %w(s) => 'scaffold'
      desc "view scaffold <list/complexlist/tabbar/toolbar/dialog> <domain> <name>", "generate a scaffold for pullentity elements."
      def scaffold(cs_type, domain, name)
        create(name, {
          :domain   => domain,
          :cs_type  => cs_type,
          :name     => name })
      end

      map %w(g) => 'generate'
      #TODO: models, bridges
      desc "generate <view> <name>", "generate a view"
      def generate(type, name)
        case
        when type =~ /view/i
          create(name)
        end
      end

    end
  end
end
