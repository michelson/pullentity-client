require 'session'
module Pullentity
  module Client
    module Generate
      class Exporter < Thor

        include ::Pullentity::Client::Utils

        class << self

          include ::Pullentity::Client::Utils

          def create(name)

          end

          def copy_defaults

          end

          def generate_files
            create_project_directory
            full_app_hash = {:app_name => @project_name, :app_name_underscore => underscore(@project_name), :platform => @device_platform}
            create_with_template('pullentity.yml', 'defaults/pullentity.yml', full_app_hash)

            create_with_template('source/assets/javascripts/test-data.js', 'defaults/test-data.js', full_app_hash)

          end

          def location
            base_location.join(@project_name)
          end

          def source_root
            File.dirname(__FILE__)
          end

        end

        map %(n) => 'new'
        desc "exporter new <name> ", "exports a new Pullentity Client project."
        long_desc "Exports a new Pullentity project"
        def new(name)

        end

      end
    end
  end
end
