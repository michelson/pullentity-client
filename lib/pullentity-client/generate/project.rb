require 'session'
module Pullentity
  module Client
    module Generate
      class Project < Thor

        include ::Pullentity::Client::Utils

        class << self

          attr_accessor :project_name, :device_platform, :app_id

          include ::Pullentity::Client::Utils

          def create(name)
            @project_name    = name

            begin
              create_directories('tmp')
              copy_defaults
              remove_old_files
              generate_files
              log "Your Pullentity Theme project is ready for you to get coding!"
            rescue => e
              error "There was an error generating your Pullentity Client project. #{e} #{e.backtrace}"
            end
          end

          def copy_defaults
          end

          def generate_files
            create_project_directory
            full_app_hash = {:app_name => @project_name, :app_name_underscore => underscore(@project_name), :platform => @device_platform}
            create_with_template('.gitignore', 'defaults/gitignore', full_app_hash)
            create_with_template('Gemfile', 'defaults/Gemfile', full_app_hash)
            create_with_template('LICENSE', 'defaults/LICENSE', full_app_hash)
            create_with_template('pullentity.yml', 'defaults/pullentity.yml', full_app_hash)

            create_with_template('config.rb', 'defaults/config', full_app_hash)
            default_templates = ['Readme.mkd']
            default_templates.each do |tempfile|
              create_with_template(tempfile, "defaults/#{tempfile}", full_app_hash)
            end

            FileUtils.cp_r(templates("app/."), location.join("source/") )

            create_with_template('source/assets/javascripts/test-data.js', 'defaults/test-data.js', full_app_hash)
            create_with_template('source/layout.haml', 'defaults/layout.haml', full_app_hash)

          end

          def create_project_directory
            create_directories('docs', 'spec',
                               "source/assets",
                               "source/assets/images",
                               "source/assets/fonts",
                               "source/assets/stylesheets",
                               "source/assets/javascripts",
                               "source/views",
                               "source/models")
          end

          def remove_old_files
          end

          def location
            base_location.join(@project_name)
          end

          def source_root
            File.dirname(__FILE__)
          end

        end

        map %(n) => 'new'
        desc "project new <name> ", "generates a new Pullentity Client project."
        long_desc "Generates a new Pullentity project. See 'pullentity help new' for more information.
                  \n\nExample:
                  \n\npullentity project new demo ==> Creates a new project skeleton."
        def new(name)
          if File.exist?(base_location.join(name))

            if yes?("#{name} already exists, do you want to override? (yes or no)")
              ::Pullentity::Client::Generate::Project.create(name)
            else
              say "Skipping #{name} because it already exists"
            end
          else
            ::Pullentity::Client::Generate::Project.create(name)
          end

        end

      end
    end
  end
end
