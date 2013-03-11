require 'session'
module Pullentity
  module Client
    module Generate
      class Project < Thor

        class << self
          attr_accessor :project_name, :device_platform, :app_id
          include ::Pullentity::Client::Utils
          # Coolstrap::Generator::Generate::Project.create('demo', 'org.codewranglers.demo', 'ipad')
          def create(name)
            @project_name    = name

            begin
              create_directories('tmp')
              copy_defaults
              remove_old_files
              generate_files
              log "Your Pullentity Client project is ready for you to get coding!"
            rescue => e
              error "There was an error generating your Pullentity Client project. #{e} #{e.backtrace}"
            end
          end

          def copy_defaults
            #FileUtils.cp(location.join("Resources/KS_nav_ui.png"),    "/tmp/")
            #FileUtils.cp(location.join("Resources/KS_nav_views.png"), "/tmp/")
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

            FileUtils.cp_r(templates("app/views/shared/."), location.join("source/views/shared") )
            FileUtils.cp_r(templates("app/assets/."), location.join("source/assets") )

            create_with_template('source/index.html.haml', 'app/index.html.haml', full_app_hash)
            create_with_template('source/layout.haml', 'app/layout.haml', full_app_hash)
            create_with_template('source/views/_home.haml', 'app/views/_home.haml', full_app_hash)

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
            #remove_files('README')
            #remove_directories('Resources')
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
        long_desc "Generates a new Pullentity Client project. See 'pullentity help new' for more information.
                  \n\nExample:
                  \n\npullentity project new demo ==> Creates a new project skeleton."
        def new(name, device_id='org.mycompany.demo', platform='iphone')
          #if yes?("You are about to generate a Pullentity Client Project, Are you ready ??")
            ::Pullentity::Client::Generate::Project.create(name, device_id, platform)
          #end
        end

      end
    end
  end
end
